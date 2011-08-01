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
 * This file was semi-automatically converted from the public-domain USGS PROJ source.
 */

/*
 * This file was manually ported to actionscript by Gregor Aisch, vis4.net
 */

package net.vis4.map.proj 
{
	import flash.geom.Point;
	import net.vis4.map.MapMath;
	
	public class LambertConformalConicProjection extends ConicProjection
	{
		private var n:Number;
		private var rho0:Number;
		private var c:Number;
	
		public function LambertConformalConicProjection(ellipsoid:Ellipsoid = null, lon_0:Number = undefined, lat_1:Number = undefined, lat_2:Number = undefined, lat_0:Number = undefined, x_0:Number = undefined, y_0:Number = undefined) 
		{
			if (ellipsoid == null) {
				minLatitude = MapMath.toRadians(0);
				maxLatitude = MapMath.toRadians(80.0);
				projectionLatitude = MapMath.QUARTERPI;
				projectionLatitude1 = 0;
				projectionLatitude2 = 0;
				initialize();
			} else {
				setEllipsoid(ellipsoid);
				projectionLongitude = lon_0;
				projectionLatitude = lat_0;
				scaleFactor = 1.0;
				falseEasting = x_0;
				falseNorthing = y_0;
				projectionLatitude1 = lat_1;
				projectionLatitude2 = lat_2;
				initialize();
			}
		}
		
		override public function project(x:Number, y:Number, out:Point):Point 
		{
			var rho:Number;
			if (Math.abs(Math.abs(y) - MapMath.HALFPI) < 1e-10)
				rho = 0.0;
			else
				rho = c * (spherical ? 
				Math.pow(Math.tan(MapMath.QUARTERPI + .5 * y), -n) :
				Math.pow(MapMath.tsfn(y, Math.sin(y), e), n));
			out.x = scaleFactor * (rho * Math.sin(x *= n));
			out.y = scaleFactor * (rho0 - rho * Math.cos(x));
			return out;
		}
		
		override public function projectInverse(x:Number, y:Number, out:Point):Point 
		{
			x /= scaleFactor;
			y /= scaleFactor;
			var rho:Number = MapMath.distance(x, y = rho0 - y);
			if (rho != 0) {
				if (n < 0.0) {
					rho = -rho;
					x = -x;
					y = -y;
				}
				if (spherical)
					out.y = 2.0 * Math.atan(Math.pow(c / rho, 1.0/n)) - MapMath.HALFPI;
				else
					out.y = MapMath.phi2(Math.pow(rho / c, 1.0/n), e);
				out.x = Math.atan2(x, y) / n;
			} else {
				out.x = 0.0;
				out.y = n > 0.0 ? MapMath.HALFPI : -MapMath.HALFPI;
			}
			return out;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			var cosphi:Number, sinphi:Number, secant:Boolean;
			
			if ( projectionLatitude1 == 0 )
				projectionLatitude1 = projectionLatitude2 = projectionLatitude;

			if (Math.abs(projectionLatitude1 + projectionLatitude2) < 1e-10)
				throw new ProjectionError();
			n = sinphi = Math.sin(projectionLatitude1);
			cosphi = Math.cos(projectionLatitude1);
			secant = Math.abs(projectionLatitude1 - projectionLatitude2) >= 1e-10;
			spherical = (es == 0.0);
			if (!spherical) {
				var ml1:Number, m1:Number;

				m1 = MapMath.msfn(sinphi, cosphi, es);
				ml1 = MapMath.tsfn(projectionLatitude1, sinphi, e);
				if (secant) {
					n = Math.log(m1 /
					   MapMath.msfn(sinphi = Math.sin(projectionLatitude2), Math.cos(projectionLatitude2), es));
					n /= Math.log(ml1 / MapMath.tsfn(projectionLatitude2, sinphi, e));
				}
				c = (rho0 = m1 * Math.pow(ml1, -n) / n);
				rho0 *= (Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) < 1e-10) ? 0. :
					Math.pow(MapMath.tsfn(projectionLatitude, Math.sin(projectionLatitude), e), n);
			} else {
				if (secant)
					n = Math.log(cosphi / Math.cos(projectionLatitude2)) /
					   Math.log(Math.tan(MapMath.QUARTERPI + .5 * projectionLatitude2) /
					   Math.tan(MapMath.QUARTERPI + .5 * projectionLatitude1));
				c = cosphi * Math.pow(Math.tan(MapMath.QUARTERPI + .5 * projectionLatitude1), n) / n;
				rho0 = (Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) < 1e-10) ? 0. :
					c * Math.pow(Math.tan(MapMath.QUARTERPI + .5 * projectionLatitude), -n);
			}
		}
		
		override public function isConformal():Boolean 
		{
			return true;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String {
			return "Lambert Conformal Conic";
		}
		
		override public function get shortName():String { return "Lambert I"; }
		
		
		
	}

}