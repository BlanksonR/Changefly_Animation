// importing the flutter material design library
import 'package:flutter/material.dart';

/* class Home to inherit from the statefulWidget class to enable the framework to redraw the widget
 * whenever there is a change in the animation value / widget
*/
class Home extends StatefulWidget{
  /* Creating instance variables for the Home class
   * String title : title of the application
   * double boxSize: value to control the size of the box (each changefly logo), 
   * boxSize value also used as the end value for tween
   * double tweenBegin: to hold value for the start value of the tween
   */
  final String title;
  final double boxSize = 100.0;
  final double tweenBegin = -100.0;

  /* 
   * Home constructor to accept the title of application from the MaterialApp in the main.dart
   */
  Home(this.title);
  // Creating the state for the stateful widget. using _HomeState which extends the State class
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  // Creating the animation object with a generic type of doulbe
  Animation<double> animation;
  /** 
   * AnimationController object to manage(stop, start, restart etc) the animation
   * the animation controller takes in the duration propert to control the duration of the animation
  */
  AnimationController controller;

  // initState to be called whenever there is a change in widget
  @override
    void initState() {
      // calling the initState method from the super class
      super.initState();
      // initializing the controller object : the Animation controller takes in 
      // the duration and the vsync in order control the animation
      controller = AnimationController(
        // duration of animation set to 1 second.
        duration: Duration(
          seconds: 1,
        ),
        // passing 'this' to vsync because _Homestate class uses TikerProviderStateMixin
        vsync: this
      );

      /**
       * Initializing the animation object using the tween (which stands for inbetween) class
       * the Tween() is a linear interpolation between a beginning and ending value
       * The tween has nothing to do with the animation, it just changes the value from beginning to end
      */
      animation = Tween(begin: widget.tweenBegin, end: widget.boxSize).animate(
        // the tween begins from -100 to 100, since widget.tweenBegin is -100 and widget.boxSize is 100
        // The tween class calls the animate method and passes the kind of animation to it
        // The CurvedAnimation class specify the kind of animation we want
        CurvedAnimation(
          // the controller is passed to the parent property of the CurvedAnimation in order to control the animation
          parent: controller,
          // In this case, Curves.easeIn is passed to the curve property of the CurvedAnimation
        // Using Curves.easeIn will animate the widget slowly and then increase with speed (a non-linear curve)
          curve: Curves.easeIn
        )
      );
      // to start the animation, the forward() method of the AnimationController is called.
      controller.forward();
    }
  
  // the default build method is called in order to use widgets in our app
  @override
  Widget build(BuildContext context){
    // I returned the Scaffold widget to help implement the layout structure of the app
    return Scaffold(
      // the scaffold has the `appbar` property which helps to create an AppBar() for the app
      // The AppBar() accepts the title of the appbar in text, it also has property such as background etc
      appBar: 
        // I passed the Text() widget to the appBar to specify the title of the appBar
        // The Text() widget also has the style property which accept the TextStyle() widget to specify color, fontsize, fontweight etc of the text
        AppBar(
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/changefly-cube.png',
                width: IconTheme.of(context).size,
                height: IconTheme.of(context).size,
              ),
            ),
          ),
          title: Hero(
            tag: 'title',
            child: Image.asset(
              'assets/changefly-name.png',
              color: Colors.white,
              width: Theme.of(context).textTheme.display4.fontSize,
            ),
          ),
        ),
      // the Scaffold class has a body property to accept any widget
      // I passed the Center widget to the body in order to place all widgets at the center of the scaffold
      body: Center(
        // Note: all classes in Flutter are widgets
        // the center class has a child property which accept a widget.
        // I used the Stack widget in order to position all widgets relative to the edge of the stack
        // All widgets were passed to the children property of the Stack
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            // to make the default build() method clean and easier to read,
            // I created the buildLogoAnimation() to create all the widget I want
            buildLogoAnimation(animation, "top"),
            buildLogoAnimation(animation, "left"),
            buildLogoAnimation(animation, "right"),
            buildNameAnimation()
          ],
        )
      ),
    );
  }

  // the buildLogoAnimation() method returns a widget which is used inside the stack
  // it accepts the Animation and a string which specify the type of logo to use
  Widget buildLogoAnimation(Animation animation, String type){
    // the AnimatedBuilder is useful for building the animation
    // it's animaiton property accepts the animation
    // the builder property is used to build the widget anytime there is change in the animation value
    return AnimatedBuilder(
      animation: animation,
      // an anonymous function is passed to the builder which accept the context and the child widget
      // I returned the Positioned widget to help me position the widget in the stack
      // Without the Positioned widget, the stack will wrapped its children widget.
      // Using the Positioned widget, it helps to position the a widget to the top, left, rigth or bottom relative to the stack
      builder: (context, child){
        return Positioned(
          // the positioned class has the child property which accept a widget, 
          // child is passed to it representing the Image passed to AnimatedBuilder
          child: child,
          /**
           * using a tenary operator to check the type of widget and specify the type animation to use
           * Basically what I'm doing is just changing the position of the child widget
           * using the values of animation returned from the Tween()
           * This allow the top logo to change its top position from -100 to 100, making it animate from top to bottom
           * Also the left logo animate / changes its left and bottom position making it increase and decrease in size and also changing its position
           * the right logo also changes its right and bottom position just like the left logo
           * the widget.boxSize is assigned to the positioned property if the type of logo isn't the corresponding property
           * this helps the buildLogoAnimation() method to be dynamic for any type of logo specify
           */
          top: type == "top" ? animation.value : widget.boxSize,
          left: type == "left" ? animation.value : widget.boxSize,
          right: type == "right" ? animation.value : widget.boxSize,
          bottom: type != "top" ? animation.value : widget.boxSize
        );
      },
      /**
       * the Image is passed to the child property of the AnimatedBuilder
       * Since the name of the images are similar except the type specified in it 
       * I just concantenated the type to the asset name, making it dynamic for any image name.
       */
      child: Image.asset("assets/changefly-cube-"+type+".png")
    );
  }

  // the buildNameAnimation() method for the animation of the Changefly logo name
  Widget buildNameAnimation(){
    // this also uses the Positioned widget to help position the widget in the stack
    return Positioned(
      left: widget.boxSize,
      right: widget.boxSize,
      top: widget.boxSize * 2,
      bottom: widget.tweenBegin,
      // the AnimatedBuilder is also used here
      child: AnimatedBuilder(
        animation: animation,
        // the image is passed to the child property of the AnimatedBuilder
        child: Image.asset("assets/changefly-name.png"),
        builder: (context, child){
          return Opacity(
            /** 
             * I used the same animation object for this, using the values of the animaton 
             * Since opacity is between 0 and 1. I checked to see if my animation value is greater than 0
             * that means if my animation value is not negative.
             * The tween begins from -100 to 100, when it increase from -100 to 1 it becomes positive
             * if the value is still negative I assigned 0.0 to the opacity, making the name logo not visible
             * when the animation / value gets to 1 and start increasing, I divide it by 100
             * Hence making the opacity start from 0.01 to 1
             */
            opacity: animation.value > 0 ? animation.value / 100 : 0.0,
            child: child
          );
        }
      )
    );
  }
}