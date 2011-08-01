/*
Copyright 2006 Jerry Huxtable

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


/*
 * This file was manually ported to actionscript by Gregor Aisch, vis4.net
 */

package net.vis4.map.proj 
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.vis4.map.*;
	
	public class Projection
	{
		
		/**
		 * The minimum latitude of the bounds of this projection
		 */
		protected var minLatitude:Number = -Math.PI/2;

		/**
		 * The minimum longitude of the bounds of this projection. This is relative to the projection centre.
		 */
		protected var minLongitude:Number = -Math.PI;

		/**
		 * The maximum latitude of the bounds of this projection
		 */
		protected var maxLatitude:Number = Math.PI/2;

		/**
		 * The maximum longitude of the bounds of this projection. This is relative to the projection centre.
		 */
		protected var maxLongitude:Number = Math.PI;

		/**
		 * The latitude of the centre of projection
		 */
		protected var projectionLatitude:Number = 0.0;

		/**
		 * The longitude of the centre of projection
		 */
		protected var projectionLongitude:Number = 0.0;

		/**
		 * Standard parallel 1 (for projections which use it)
		 */
		protected var projectionLatitude1:Number = 0.0;

		/**
		 * Standard parallel 2 (for projections which use it)
		 */
		protected var projectionLatitude2:Number = 0.0;

		/**
		 * The projection scale factor
		 */
		protected var scaleFactor:Number = 1.0;

		/**
		 * The false Easting of this projection
		 */
		protected var falseEasting:Number = 0;

		/**
		 * The false Northing of this projection
		 */
		protected var falseNorthing:Number = 0;

		/**
		 * The latitude of true scale. Only used by specific projections.
		 */
		protected var trueScaleLatitude:Number = 0.0;

		/**
		 * The equator radius
		 */
		protected var a:Number = 0;

		/**
		 * The eccentricity
		 */
		protected var e:Number = 0;

		/**
		 * The eccentricity squared
		 */
		protected var es:Number = 0;

		/**
		 * 1-(eccentricity squared)
		 */
		protected var one_es:Number = 0;

		/**
		 * 1/(1-(eccentricity squared))
		 */
		protected var rone_es:Number = 0;

		/**
		 * The ellipsoid used by this projection
		 */
		protected var ellipsoid:Ellipsoid;

		/**
		 * True if this projection is using a sphere (es == 0)
		 */
		protected var spherical:Boolean;

		/**
		 * True if this projection is geocentric
		 */
		protected var geocentric:Boolean;

		/**
		 * The name of this projection
		 */
		protected var name:String = '';

		/**
		 * Conversion factor from metres to whatever units the projection uses.
		 */
		protected var fromMetres:Number = 1;

		/**
		 * The total scale factor = Earth radius * units
		 */
		private var totalScale:Number = 0;

		/**
		 * falseEasting, adjusted to the appropriate units using fromMetres
		 */
		private var totalFalseEasting:Number = 0;

		/**
		 * falseNorthing, adjusted to the appropriate units using fromMetres
		 */
		private var totalFalseNorthing:Number = 0;

		// Some useful constants
		protected static const EPS10:Number = 1e-10;
		protected static const RTD:Number = 180.0/Math.PI;
		protected static const DTR:Number = Math.PI/180.0;
		
		public function Projection() {
			setEllipsoid( Ellipsoid.SPHERE );
		}
		
		public function clone():Projection {
			// todo
			return null;
		}
		
		/**
		 * Project a lat/long point (in degrees), producing a result in metres
		 */
		public function transform(src:Point, dst:Point):Point {
			var x:Number = src.x*DTR;
			if ( projectionLongitude != 0 )
				x = MapMath.normalizeLongitude( x-projectionLongitude );
			project(x, src.y*DTR, dst);
			dst.x = totalScale * dst.x + totalFalseEasting;
			dst.y = totalScale * dst.y + totalFalseNorthing;
			return dst;
		}

		/**
		 * Project a lat/long point, producing a result in metres
		 */
		public function transformRadians(src:Point, dst:Point ):Point {
			var x:Number = src.x;
			if ( projectionLongitude != 0 )
				x = MapMath.normalizeLongitude( x-projectionLongitude );
			project(x, src.y, dst);
			dst.x = totalScale * dst.x + totalFalseEasting;
			dst.y = totalScale * dst.y + totalFalseNorthing;
			return dst;
		}

		/**
		 * The method which actually does the projection. This should be overridden for all projections.
		 */
		public function project(lplam:Number, lpphi:Number, out:Point):Point {
			out.x = lplam
			out.y = lpphi;
			return out;
		}

		/**
		 * Project a number of lat/long points (in degrees), producing a result in metres
		 */
		public function transformMultiple(srcPoints:Array, srcOffset:int, dstPoints:Array, dstOffset:int, numPoints:int):void {
			var _in:Point = new Point();
			var out:Point = new Point();
			for (var i:int = 0; i < numPoints; i++) {
				_in.x = srcPoints[srcOffset++];
				_in.y = srcPoints[srcOffset++];
				transform(_in, out);
				dstPoints[dstOffset++] = out.x;
				dstPoints[dstOffset++] = out.y;
			}
		}

		/**
		 * Project a number of lat/long points (in radians), producing a result in metres
		 */
		public function transformMultipleRadians(srcPoints:Array, srcOffset:int, dstPoints:Array, dstOffset:int, numPoints:int):void {
			var _in:Point = new Point();
			var out:Point = new Point();
			for (var i:int = 0; i < numPoints; i++) {
				_in.x = srcPoints[srcOffset++];
				_in.y = srcPoints[srcOffset++];
				transform(_in, out);
				dstPoints[dstOffset++] = out.x;
				dstPoints[dstOffset++] = out.y;
			}
		}

		/**
		 * Inverse-project a point (in metres), producing a lat/long result in degrees
		 */
		public function inverseTransform(src:Point, dst:Point):Point {
			var x:Number = (src.x - totalFalseEasting) / totalScale;
			var y:Number = (src.y - totalFalseNorthing) / totalScale;
			projectInverse(x, y, dst);
			if (dst.x < -Math.PI)
				dst.x = -Math.PI;
			else if (dst.x > Math.PI)
				dst.x = Math.PI;
			if (projectionLongitude != 0)
				dst.x = MapMath.normalizeLongitude(dst.x+projectionLongitude);
			dst.x *= RTD;
			dst.y *= RTD;
			return dst;
		}

		/**
		 * Inverse-project a point (in metres), producing a lat/long result in radians
		 */
		public function inverseTransformRadians(src:Point, dst:Point):Point {
			var x:Number = (src.x - totalFalseEasting) / totalScale;
			var y:Number = (src.y - totalFalseNorthing) / totalScale;
			projectInverse(x, y, dst);
			if (dst.x < -Math.PI)
				dst.x = -Math.PI;
			else if (dst.x > Math.PI)
				dst.x = Math.PI;
			if (projectionLongitude != 0)
				dst.x = MapMath.normalizeLongitude(dst.x+projectionLongitude);
			return dst;
		}

		/**
		 * The method which actually does the inverse projection. This should be overridden for all projections.
		 */
		public function projectInverse(xyx:Number, xyy:Number, out:Point):Point {
			out.x = xyx;
			out.y = xyy;
			return out;
		}

		/**
		 * Inverse-project a number of points (in metres), producing a lat/long result in degrees
		 */
		public function inverseTransformMultiple(srcPoints:Array, srcOffset:int, dstPoints:Array, dstOffset:int, numPoints:int):void 
		{
			var _in:Point = new Point();
			var out:Point = new Point();
			for (var i:int = 0; i < numPoints; i++) {
				_in.x = srcPoints[srcOffset++];
				_in.y = srcPoints[srcOffset++];
				inverseTransform(_in, out);
				dstPoints[dstOffset++] = out.x;
				dstPoints[dstOffset++] = out.y;
			}
		}

		/**
		 * Inverse-project a number of points (in metres), producing a lat/long result in radians
		 */
		public function inverseTransformMultipleRadians(srcPoints:Array, srcOffset:int, dstPoints:Array, dstOffset:int, numPoints:int):void 
		{
			var _in:Point = new Point();
			var out:Point = new Point();
			for (var i:int = 0; i < numPoints; i++) {
				_in.x = srcPoints[srcOffset++];
				_in.y = srcPoints[srcOffset++];
				inverseTransformRadians(_in, out);
				dstPoints[dstOffset++] = out.x;
				dstPoints[dstOffset++] = out.y;
			}
		}

		/**
		 * Finds the smallest lat/long rectangle wholly inside the given view rectangle.
		 * This is only a rough estimate.
		 */
		public function inverseTransformRectangle(r:Rectangle):Rectangle 
		{
			var _in:Point = new Point();
			var out:Point = new Point();
			var bounds:Rectangle;
			var ix:int, iy:int, x:Number, y:Number;
			
			if (isRectilinear()) {
				for (ix = 0; ix < 2; ix++) {
					x = r.x + r.width * ix;
					for (iy = 0; iy < 2; iy++) {
						y = r.y+r.height*iy;
						_in.x = x;
						_in.y = y;
						inverseTransform(_in, out);
						if (ix == 0 && iy == 0)
							bounds = new Rectangle(out.x, out.y, 0, 0);
						else
							bounds.offset(out.x, out.y);
					}
				}
			} else {
				for (ix = 0; ix < 7; ix++) {
					x = r.x+r.width*ix/6;
					for (iy = 0; iy < 7; iy++) {
						y = r.y+r.height*iy/6;
						_in.x = x;
						_in.y = y;
						inverseTransform(_in, out);
						if (ix == 0 && iy == 0)
							bounds = new Rectangle(out.x, out.y, 0, 0);
						else
							bounds.offset(out.x, out.y);
					}
				}
			}
			return bounds;
		}
		
		/**
		 * Transform a bounding box. This is only a rough estimate.
		 */
		public function transformRectangle( r:Rectangle ):Rectangle 
		{
			var _in:Point = new Point();
			var out:Point = new Point();
			var bounds:Rectangle;
			var ix:int, iy:int, x:Number, y:Number;
			
			if ( isRectilinear() ) {
				for (ix = 0; ix < 2; ix++) {
					x = r.x + r.width * ix;
					for (iy = 0; iy < 2; iy++) {
						y = r.y+r.height*iy;
						_in.x = x;
						_in.y = y;
						transform(_in, out);
						if (ix == 0 && iy == 0)
							bounds = new Rectangle(out.x, out.y, 0, 0);
						else
							bounds.offset(out.x, out.y);
					}
				}
			} else {
				for (ix = 0; ix < 7; ix++) {
					x = r.x+r.width*ix/6;
					for (iy = 0; iy < 7; iy++) {
						y = r.y+r.height*iy/6;
						_in.x = x;
						_in.y = y;
						transform(_in, out);
						if (ix == 0 && iy == 0)
							bounds = new Rectangle(out.x, out.y, 0, 0);
						else
							bounds.offset(out.x, out.y);
					}
				}
				
			}
			
			return bounds;
		}
		
		/**
		 * Returns true if this projection is conformal
		 */
		public function isConformal():Boolean {
			return isRectilinear();
		}
		
		/**
		 * Returns true if this projection is equal area
		 */
		public function isEqualArea():Boolean {
			return false;
		}
		
		/**
		 * Returns true if this projection has an inverse
		 */
		public function hasInverse():Boolean {
			return false;
		}

		/**
		 * Returns true if lat/long lines form a rectangular grid for this projection
		 */
		public function isRectilinear():Boolean {
			return false;
		}

		/**
		 * Returns true if latitude lines are parallel for this projection
		 */
		public function parallelsAreParallel():Boolean {
			return isRectilinear();
		}

		/**
		 * Returns true if the given lat/long point is visible in this projection
		 */
		public function inside(x:Number, y:Number):Boolean {
			x = normalizeLongitude(Number(x*DTR-projectionLongitude) );
			return minLongitude <= x && x <= maxLongitude && minLatitude <= y && y <= maxLatitude;
		}

		/**
		 * Set the name of this projection.
		 */
		public function setName( name:String ):void {
			this.name = name;
		}
		
		public function getName():String {
			if ( name != null )
				return name;
			return toString();
		}

		
		/**
		 * Get a string which describes this projection in PROJ.4 format.
		 */
		/*public function getPROJ4Description():String {
			AngleFormat format = new AngleFormat( AngleFormat.ddmmssPattern, false );
			StringBuffer sb = new StringBuffer();
			sb.append(
				"+proj="+getName()+
				" +a="+a
			);
			if ( es != 0 )
				sb.append( " +es="+es );
			sb.append( " +lon_0=" );
			format.format( projectionLongitude, sb, null );
			sb.append( " +lat_0=" );
			format.format( projectionLatitude, sb, null );
			if ( falseEasting != 1 )
				sb.append( " +x_0="+falseEasting );
			if ( falseNorthing != 1 )
				sb.append( " +y_0="+falseNorthing );
			if ( scaleFactor != 1 )
				sb.append( " +k="+scaleFactor );
			if ( fromMetres != 1 )
				sb.append( " +fr_meters="+fromMetres );
			return sb.toString();
		}
		*/

		public function toString():String {
			return "None";
		}

		/**
		 * Set the minimum latitude. This is only used for Shape clipping and doesn't affect projection.
		 */
		public function setMinLatitude( minLatitude:Number ):void {
			this.minLatitude = minLatitude;
		}
		
		public function getMinLatitude():Number {
			return minLatitude;
		}

		/**
		 * Set the maximum latitude. This is only used for Shape clipping and doesn't affect projection.
		 */
		public function setMaxLatitude( maxLatitude:Number ):void  {
			this.maxLatitude = maxLatitude;
		}
		
		public function getMaxLatitude():Number {
			return maxLatitude;
		}

		public function getMaxLatitudeDegrees():Number {
			return maxLatitude*RTD;
		}

		public function getMinLatitudeDegrees():Number {
			return minLatitude*RTD;
		}

		public function setMinLongitude( minLongitude:Number ):void  {
			this.minLongitude = minLongitude;
		}
		
		public function getMinLongitude():Number {
			return minLongitude;
		}

		public function setMinLongitudeDegrees( minLongitude:Number ):void {
			this.minLongitude = DTR*minLongitude;
		}
		
		public function getMinLongitudeDegrees():Number {
			return minLongitude*RTD;
		}

		public function setMaxLongitude( maxLongitude:Number ):void {
			this.maxLongitude = maxLongitude;
		}
		
		public function getMaxLongitude():Number {
			return maxLongitude;
		}

		public function setMaxLongitudeDegrees( maxLongitude:Number ):void {
			this.maxLongitude = DTR*maxLongitude;
		}
		
		public function getMaxLongitudeDegrees():Number {
			return maxLongitude*RTD;
		}

		/**
		 * Set the projection latitude in radians.
		 */
		public function setProjectionLatitude( projectionLatitude:Number ):void {
			this.projectionLatitude = projectionLatitude;
		}
		
		public function getProjectionLatitude():Number {
			return projectionLatitude;
		}
		
		/**
		 * Set the projection latitude in degrees.
		 */
		public function setProjectionLatitudeDegrees( projectionLatitude:Number ):void {
			this.projectionLatitude = DTR*projectionLatitude;
		}
		
		public function getProjectionLatitudeDegrees():Number {
			return projectionLatitude*RTD;
		}
		
		/**
		 * Set the projection longitude in radians.
		 */
		public function setProjectionLongitude( projectionLongitude:Number ):void {
			this.projectionLongitude = normalizeLongitudeRadians( projectionLongitude );
		}
		
		public function getProjectionLongitude():Number {
			return projectionLongitude;
		}
		
		/**
		 * Set the projection longitude in degrees.
		 */
		public function setProjectionLongitudeDegrees( projectionLongitude:Number ):void {
			this.projectionLongitude = DTR*projectionLongitude;
		}
		
		public function getProjectionLongitudeDegrees():Number {
			return projectionLongitude*RTD;
		}
		
		/**
		 * Set the latitude of true scale in radians. This is only used by certain projections.
		 */
		public function setTrueScaleLatitude( trueScaleLatitude:Number ):void {
			this.trueScaleLatitude = trueScaleLatitude;
		}
		
		public function getTrueScaleLatitude():Number {
			return trueScaleLatitude;
		}
		
		/**
		 * Set the latitude of true scale in degrees. This is only used by certain projections.
		 */
		public function setTrueScaleLatitudeDegrees( trueScaleLatitude:Number ):void {
			this.trueScaleLatitude = DTR*trueScaleLatitude;
		}
		
		public function getTrueScaleLatitudeDegrees():Number {
			return trueScaleLatitude*RTD;
		}
		
		/**
		 * Set the projection latitude in radians.
		 */
		public function setProjectionLatitude1( projectionLatitude1:Number ):void {
			this.projectionLatitude1 = projectionLatitude1;
		}
		
		public function getProjectionLatitude1():Number {
			return projectionLatitude1;
		}
		
		/**
		 * Set the projection latitude in degrees.
		 */
		public function setProjectionLatitude1Degrees( projectionLatitude1:Number ):void {
			this.projectionLatitude1 = DTR*projectionLatitude1;
		}
		
		public function getProjectionLatitude1Degrees():Number {
			return projectionLatitude1*RTD;
		}
		
		/**
		 * Set the projection latitude in radians.
		 */
		public function setProjectionLatitude2( projectionLatitude2:Number ):void {
			this.projectionLatitude2 = projectionLatitude2;
		}
		
		public function getProjectionLatitude2():Number {
			return projectionLatitude2;
		}
		
		/**
		 * Set the projection latitude in degrees.
		 */
		public function setProjectionLatitude2Degrees( projectionLatitude2:Number ):void {
			this.projectionLatitude2 = DTR*projectionLatitude2;
		}
		
		public function getProjectionLatitude2Degrees():Number {
			return projectionLatitude2*RTD;
		}
		
		/**
		 * Set the false Northing in projected units.
		 */
		public function setFalseNorthing( falseNorthing:Number ):void {
			this.falseNorthing = falseNorthing;
		}
		
		public function getFalseNorthing():Number {
			return falseNorthing;
		}
		
		/**
		 * Set the false Easting in projected units.
		 */
		public function setFalseEasting( falseEasting:Number ):void {
			this.falseEasting = falseEasting;
		}
		
		public function getFalseEasting():Number {
			return falseEasting;
		}
		
		/**
		 * Set the projection scale factor. This is set to 1 by default.
		 */
		public function setScaleFactor( scaleFactor:Number ):void {
			this.scaleFactor = scaleFactor;
		}

		public function getScaleFactor():Number {
			return scaleFactor;
		}

		public function getEquatorRadius():Number {
			return a;
		}

		/**
		 * Set the conversion factor from metres to projected units. This is set to 1 by default.
		 */
		public function setFromMetres(fromMetres:Number):void {
			this.fromMetres = fromMetres;
		}
		
		public function getFromMetres():Number {
			return fromMetres;
		}
		
		public function setEllipsoid(ellipsoid:Ellipsoid):void {
			this.ellipsoid = ellipsoid;
			a = ellipsoid.equatorRadius;
			e = ellipsoid.eccentricity;
			es = ellipsoid.eccentricity2;
		}
		
		public function getEllipsoid():Ellipsoid {
			return ellipsoid;
		}

		/**
		 * Returns the ESPG code for this projection, or 0 if unknown.
		 */
		public function getEPSGCode():int {
			return 0;
		}
		
		/**
		 * Initialize the projection. This should be called after setting parameters and before using the projection.
		 * This is for performance reasons as initialization may be expensive.
		 */
		public function initialize():void {
			spherical = e == 0.0;
			one_es = 1-es;
			rone_es = 1.0/one_es;
			totalScale = a * fromMetres;
			totalFalseEasting = falseEasting * fromMetres;
			totalFalseNorthing = falseNorthing * fromMetres;		
		}

		public static function normalizeLongitude(angle:Number):Number {
			if (!isFinite(angle) || isNaN(angle))
				throw new ArgumentError("Infinite longitude");
			while (angle > 180)
				angle -= 360;
			while (angle < -180)
				angle += 360;
			return angle;
		}

		public static function normalizeLongitudeRadians(angle:Number):Number {
			if (!isFinite(angle) || isNaN(angle))
				throw new ArgumentError("Infinite longitude");
			while (angle > Math.PI)
				angle -= MapMath.TWOPI;
			while (angle < -Math.PI)
				angle += MapMath.TWOPI;
			return angle;
		}

		public function get shortName():String { return toString(); }
		
		public function get inventor():String { return 'unknown'; }
		
		public function get year():int { return -1; }
	}

}