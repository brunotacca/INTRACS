# INTRACS Project Architecture

This project is composed of two softwares, the multiplatform mobile application and the inertial data device transmitter. The mobile app is the complex one for now, as the device is only meant to gather and transmit the raw inertial data through bluetooth.

## INTRACS Software

The app project was made following the guidelines of Uncle Bob's Clean Architecture and programming patterns and principles like GRASP, GoF and SOLID. The onion visualization of clean architecture of this project is shown below, it's composed of 3 outer layers, 3 adapter layers, and 2 inner layers.

<p align="center">
<img src="imgs/fig39-intracs-arquitetura-redonda-camadas-separadas.png" height="300px">
</p>

The arrows between the layers represents dependency, and dependency means that one object at the start of the arrow depends on (uses an) object at the end of the arrow. In clean architecture this is the dependency rule, and must be preserved throughout the different layers of the architecture. The dependency rule states that no inner layer should depend on an outside layer, which means that the components inside a layer should only have dependency pointing inwards the architecture, not outwards.

<p align="center">
<img src="imgs/fig26-intracs-arquitetura-camadas-linear.png" height="250px">
</p>

In the image above, you can see a different layout of the architecture, the solid black dots represents concrete classes and the white dots represents abstract classes. Both of the arrows represents dependency, the black one you can read as *"use"* and the white one you can read as *"implements"*.

As you can see there are many *dots* inside each different layer in order to preserve the dependency rule, each of those dots represents a component inside the given layer. There are many different components, lets start from inside out.

### Inner Layer - Entities

The entities layer exists to represent business rules and can be viewed as structured model of the business, which defines different entities, relation between entities and rules and functions of them. The entities classes made by the effort of trying to bring the outside world problem (reality) into code, they can be seen as the highest tier of abstraction of rules.There is still no concept of application inside this layer, because these concepts lies on the next layer, the application layer.

### Inner Layer - Application

When business rules starts to merge with the techinicality of an application, the responsibility for these rules falls over components of this layer. The major components of this layer are the use cases, they are a simple representation of an automated process, receiving an input, maybe fetching some data from outside, doing some manipulation with this input and the Entities, and by the end, calling an output.

The input port of the use case is defined by his abstract class with an InputDTO (Data Transfer Object), this guarantees that an external object calling this abstract class must pass the input object as parameter. The use case can decide to fetch data outside, for this it can define an abstract class called DataAccess and use the abstraction, the next layer will take care of implement that. It can also use Entities to work with, and at the end it will produce a result, this result will be thrown as a parameter of the output port. The output port is another abstraction with another OutputDTO, the next layer will take care of implement that.

As you can see, many of the responsibilities of a *"use case"* was taken away and given to the next layers. Things like fetching data from databases, showing information on the screen and managing the input parameter correctly doesn't exists here, the use case can produce errors/exceptions based on the input of course, but that belongs to the application rules it was designed for.

Since all those responsibilites are given to outer components through dependency inversion, the next set of layers, called Adapters, must have components that implements those abstractions to follow its the definitions.

### Adapter Layer - Controllers

### Adapter Layer - Gateways

### Adapter Layer - Presenters

### Outer Layer - Visualization

### Outer Layer - Devices


### Outer Layer - DataSources



## INTRACS Device 

### Inertial BLE Transmitter