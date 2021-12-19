import 'dart:math';

import 'package:intracs_entities/entities.dart';
import 'package:intracs_gateways/gateways.dart';

final RTQF_Fusion rtqfFusion = RTQF_Fusion();

class RTQF_Fusion extends ComputingMethodWithEngine {
  @override
  ComputingMethod get method => ComputingMethod(
        uniqueName: "RQTF_Fusion",
        description: "Simplified version of Kalman Filter",
        inputNames: [
          "accX",
          "accY",
          "accZ",
          "gyrX",
          "gyrY",
          "gyrZ",
          "magX",
          "magY",
          "magZ"
        ],
        outputNames: [
          "PoseX",
          "PoseY",
          "PoseZ",
        ],
      );

  final _FusionRTQF fusion = _FusionRTQF(0.02, true, true, true);
  final Map<int, _FusionRTQF> fusions = {};
  @override
  Future<ComputedData> compute(RawData rawData) async {
    if (!fusions.containsKey(rawData.sensor.number)) {
      fusions
          .addAll({rawData.sensor.number: _FusionRTQF(0.02, true, true, true)});
    }

    await fusions[rawData.sensor.number]!.newIMUData(
      rawData.getGyro(),
      rawData.getAccel(),
      rawData.getCompass(),
      DateTime.now().millisecondsSinceEpoch,
    );

    // Converts fusion result from rad to degree
    _Vector3 fusionResult =
        fusions[rawData.sensor.number]!.fusionPose.radToDegree();

    return ComputedData(
      timestamp: DateTime.now(),
      group: rawData.sensor.number,
      count: rawData.count,
      names: [
        "PoseX",
        "PoseY",
        "PoseZ",
      ],
      values: [
        fusionResult.x,
        fusionResult.y,
        fusionResult.z,
      ],
    );
  }
}

class _FusionRTQF {
  // Slerp power controls the fusion and can be between 0 and 1
  // 0 means that only gyros are used, 1 means that only accels/compass are used
  // In-between gives the fusion mix.
  final double slerpPower;
  _Quaternion?
      _rotationDelta; // amount by which measured state differs from predicted
  _Quaternion? _rotationPower; // delta raised to the appopriate power
  _Vector3? _rotationUnitVector; // the vector part of the rotation delta

  // use of sensors in the fusion algorithm can be controlled here
  // change any of these to false to disable that sensor
  final bool enableGyro;
  final bool enableAccel;
  final bool enableCompass;

  // Fusion result
  _Vector3 _fusionPose = _Vector3(0.0, 0.0, 0.0);

  _FusionRTQF(
    this.slerpPower,
    this.enableGyro,
    this.enableAccel,
    this.enableCompass,
  );
  _Vector3 get fusionPose => _fusionPose;

  // Transformation variables
  _Quaternion _fusionQPose = _Quaternion(0.0, _Vector3(0.0, 0.0, 0.0));
  _Vector3 _measuredPose = _Vector3(0.0, 0.0, 0.0);
  _Quaternion _measuredQPose = _Quaternion(0.0, _Vector3(0.0, 0.0, 0.0));

  // First entry flag
  bool _firstTime = true;
  int _lastFusionTime =
      DateTime.now().millisecondsSinceEpoch; // for delta time calculation
  double _timeDelta = -999.0; // time between predictions

  void reset() {
    _firstTime = true;
    _fusionPose = _Vector3(0.0, 0.0, 0.0);
    _fusionQPose = _fusionQPose.fromEuler(_fusionPose);
    _measuredPose = _Vector3(0.0, 0.0, 0.0);
    _measuredQPose = _measuredQPose.fromEuler(_measuredPose);
  }

  Future<void> newIMUData(
    _Vector3 gyro,
    _Vector3 accel,
    _Vector3 compass,
    int timestamp,
  ) async {
    if (_firstTime) {
      _lastFusionTime = timestamp;

      // calculates _measuredPose
      await calculatePose(accel, compass);

      // initialize the poses
      _fusionQPose = _fusionQPose.fromEuler(_measuredPose);
      _fusionPose = _measuredPose;
      _firstTime = false;
    } else {
      _Vector3 fusionGyro;
      _timeDelta = (timestamp - _lastFusionTime).toDouble() / 1000.0;
      _lastFusionTime = timestamp;
      if (_timeDelta <= 0.0) return;

      // calculates _measuredPose
      await calculatePose(accel, compass);

      // predict();

      double x2, y2, z2;
      double qs, qx, qy, qz;

      qs = _fusionQPose.scalar;
      qx = _fusionQPose.x;
      qy = _fusionQPose.y;
      qz = _fusionQPose.z;

      if (enableGyro)
        fusionGyro = gyro;
      else
        fusionGyro = _Vector3(0.0, 0.0, 0.0);

      x2 = fusionGyro.x / 2.0;
      y2 = fusionGyro.y / 2.0;
      z2 = fusionGyro.z / 2.0;

      // Predict new state
      double fqp_scalar = (qs + (-x2 * qx - y2 * qy - z2 * qz) * _timeDelta);
      double fqp_x = (qx + (x2 * qs + z2 * qy - y2 * qz) * _timeDelta);
      double fqp_y = (qy + (y2 * qs - z2 * qx + x2 * qz) * _timeDelta);
      double fqp_z = (qz + (z2 * qs + y2 * qx - x2 * qy) * _timeDelta);

      _fusionQPose = _Quaternion(fqp_scalar, _Vector3(fqp_x, fqp_y, fqp_z));

      // update();
      if (slerpPower >= 0.0) {
        if (enableCompass || enableAccel) {
          // calculate rotation delta
          _rotationDelta = (_fusionQPose.conjugate()).multiply(_measuredQPose);
          _rotationDelta = _rotationDelta!.normalize();

          // take it to the power (0 to 1) to give the desired amount of correction
          double theta = acos(_rotationDelta!.scalar);
          double sinPowerTheta = sin(theta * slerpPower);
          double cosPowerTheta = cos(theta * slerpPower);

          _rotationUnitVector =
              _Vector3(_rotationDelta!.x, _rotationDelta!.y, _rotationDelta!.z);
          _rotationUnitVector = _rotationUnitVector!.normalize();

          _rotationPower = _Quaternion(
              cosPowerTheta,
              _Vector3(
                  sinPowerTheta * _rotationUnitVector!.x,
                  sinPowerTheta * _rotationUnitVector!.y,
                  sinPowerTheta * _rotationUnitVector!.z));
          _rotationPower = _rotationPower!.normalize();

          //  multiple this by predicted value to get result
          _fusionQPose = _fusionQPose.multiply(_rotationPower!);
        }
      }
      _fusionQPose = _fusionQPose.normalize();

      _fusionPose = _fusionQPose.toEuler();
    }
    return;
  }

  Future<void> calculatePose(_Vector3 accel, _Vector3 mag) async {
    _Quaternion? m;
    _Quaternion? q;
    bool compassValid = (mag.x != 0) || (mag.y != 0) || (mag.z != 0);
    if (enableAccel) {
      _measuredPose = accel.accelToEuler();
    } else {
      _measuredPose = _fusionPose;
    }
    if (enableCompass && compassValid) {
      double cosX2 = cos(_measuredPose.x / 2.0);
      double sinX2 = sin(_measuredPose.x / 2.0);
      double cosY2 = cos(_measuredPose.y / 2.0);
      double sinY2 = sin(_measuredPose.y / 2.0);

      double q_scalar = cosX2 * cosY2;
      double q_x = sinX2 * cosY2;
      double q_y = cosX2 * sinY2;
      double q_z = -1 * sinX2 * sinY2;
      q = _Quaternion(q_scalar, _Vector3(q_x, q_y, q_z));

      //   normalize();
      double m_scalar = 0;
      double m_x = mag.x;
      double m_y = mag.y;
      double m_z = mag.z;
      m = _Quaternion(m_scalar, _Vector3(m_x, m_y, m_z));

      // m = q * m * q.conjugate();
      m = q.multiply(m).multiply(q.conjugate());

      _measuredPose = _measuredPose.copyWith(z: -1 * atan2(m.y, m.x));
    } else {
      _measuredPose = _measuredPose.copyWith(z: _fusionPose.z);
    }

    _measuredQPose = _measuredQPose.fromEuler(_measuredPose);

    //  check for quaternion aliasing. If the quaternion has the wrong sign
    //  the kalman filter will be very unhappy.
    int maxIndex = -1;
    double maxVal = -1000;

    for (int i = 0; i < 4; i++) {
      if (_measuredQPose.data[i].abs() > maxVal) {
        maxVal = _measuredQPose.data[i];
        maxIndex = i;
      }
    }

    //  if the biggest component has a different sign in the measured and kalman poses,
    //  change the sign of the measured pose to match.
    if (((_measuredQPose.data[maxIndex] < 0) &&
            (_fusionQPose.data[maxIndex] > 0)) ||
        ((_measuredQPose.data[maxIndex] > 0) &&
            (_fusionQPose.data[maxIndex] < 0))) {
      double ch_scalar = (-1 * _measuredQPose.scalar);
      double ch_x = (-1 * _measuredQPose.x);
      double ch_y = (-1 * _measuredQPose.y);
      double ch_z = (-1 * _measuredQPose.z);
      _measuredQPose = _Quaternion(ch_scalar, _Vector3(ch_x, ch_y, ch_z));
      _measuredPose = _measuredQPose.toEuler();
    }

    return;
  }
}

class _Vector3 {
  final double x;
  final double y;
  final double z;
  _Vector3(this.x, this.y, this.z);

  _Vector3 normalize() {
    double length = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
    if ((length == 0) || (length == 1)) return this;
    double nx = this.x / length;
    double ny = this.y / length;
    double nz = this.z / length;
    return _Vector3(nx, ny, nz);
  }

  _Vector3 accelToEuler() {
    _Vector3 normVector = this.normalize();

    double roll = atan2(normVector.y, normVector.z);
    double pitch = -1 *
        atan2(normVector.x, sqrt(pow(normVector.y, 2) + pow(normVector.z, 2)));
    double yaw = 0;

    return _Vector3(roll, pitch, yaw);
  }

  _Vector3 radToDegree() {
    const constRadToDegree = 180.0 / pi;

    return _Vector3(
      this.x * constRadToDegree,
      this.y * constRadToDegree,
      this.z * constRadToDegree,
    );
  }

  _Vector3 copyWith({
    double? x,
    double? y,
    double? z,
  }) {
    return _Vector3(
      x ?? this.x,
      y ?? this.y,
      z ?? this.z,
    );
  }

  @override
  String toString() =>
      '_Vector3(x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)})';
}

extension RawDataVector3 on RawData {
  _Vector3 getAccel() {
    return _Vector3(
      this.accelerometer!.x!,
      this.accelerometer!.y!,
      this.accelerometer!.z!,
    );
  }

  _Vector3 getGyro() {
    return _Vector3(
      this.gyroscope!.x!,
      this.gyroscope!.y!,
      this.gyroscope!.z!,
    );
  }

  _Vector3 getCompass() {
    return _Vector3(
      this.magnetometer!.x!,
      this.magnetometer!.y!,
      this.magnetometer!.z!,
    );
  }
}

class _Quaternion {
  final double scalar; // scalar
  final _Vector3 vector3;
  double get x => vector3.x; // x
  double get y => vector3.y; // y
  double get z => vector3.z; // z
  List<double> get data => [scalar, x, y, z];
  _Quaternion(this.scalar, this.vector3);

  _Vector3 toEuler() {
    double vx = (atan2(2.0 * (y * z + scalar * x), 1 - 2.0 * (x * x + y * y)));
    double vy = (asin(2.0 * (scalar * y - x * z)));
    double vz = (atan2(2.0 * (x * y + scalar * z), 1 - 2.0 * (y * y + z * z)));

    return _Vector3(
      vx,
      vy,
      vz,
    );
  }

  _Quaternion fromEuler(_Vector3 vec) {
    double cosX2 = cos(vec.x / 2.0);
    double sinX2 = sin(vec.x / 2.0);
    double cosY2 = cos(vec.y / 2.0);
    double sinY2 = sin(vec.y / 2.0);
    double cosZ2 = cos(vec.z / 2.0);
    double sinZ2 = sin(vec.z / 2.0);

    double scalar = cosX2 * cosY2 * cosZ2 + sinX2 * sinY2 * sinZ2;
    double x = sinX2 * cosY2 * cosZ2 - cosX2 * sinY2 * sinZ2;
    double y = cosX2 * sinY2 * cosZ2 + sinX2 * cosY2 * sinZ2;
    double z = cosX2 * cosY2 * sinZ2 - sinX2 * sinY2 * cosZ2;

    _Quaternion quatFromEuler = _Quaternion(scalar, _Vector3(x, y, z));
    return quatFromEuler.normalize();
  }

  _Quaternion normalize() {
    double length = sqrt(pow(scalar, 2) + pow(x, 2) + pow(y, 2) + pow(z, 2));

    if ((length == 0) || (length == 1)) return this;

    double sc = scalar / length;
    double nx = x / length;
    double ny = y / length;
    double nz = z / length;
    return _Quaternion(sc, _Vector3(nx, ny, nz));
  }

  _Quaternion multiply(_Quaternion qb) {
    _Quaternion qa = this;

    double r_scalar =
        qa.scalar * qb.scalar - qa.x * qb.x - qa.y * qb.y - qa.z * qb.z;
    double r_x =
        qa.scalar * qb.x + qa.x * qb.scalar + qa.y * qb.z - qa.z * qb.y;
    double r_y =
        qa.scalar * qb.y - qa.x * qb.z + qa.y * qb.scalar + qa.z * qb.x;
    double r_z =
        qa.scalar * qb.z + qa.x * qb.y - qa.y * qb.x + qa.z * qb.scalar;

    return _Quaternion(r_scalar, _Vector3(r_x, r_y, r_z));
  }

  _Quaternion conjugate() {
    return _Quaternion(
      this.scalar,
      _Vector3(
        -1 * this.x,
        -1 * this.y,
        -1 * this.z,
      ),
    );
  }

  @override
  String toString() =>
      '_Quaternion(scalar: ${scalar.toStringAsFixed(2)}, vector3: $vector3)';
}
