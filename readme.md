as3proj
=======

![screenshot of rendered maps](http://vis4.net/blog/wp-content/uploads/2010/04/as3proj1.png)

as3proj is a collection of map projection classes which you can use to convert geographical coodinates (pairs of latitude and longitude values) into screen coordinates. It is a port from the Java Map Projection Library[1] by Jerry Huxtable, which is itself a port from the famous PROJ.4 library[2].

1 http://www.jhlabs.com/java/maps/proj/
2 http://trac.osgeo.org/proj/

### Usage example

	var lat:Number, 
		lng:Number, 
		proj:Projection, 
		p:Point;
		
	lat = 40.2302; // degrees
	lng = 24.32434; // degrees
	proj = new RobinsonProjection();
	proj.initialize();
	p = proj.project(lat, lng, new Point());

	// p contains converted values in metres


