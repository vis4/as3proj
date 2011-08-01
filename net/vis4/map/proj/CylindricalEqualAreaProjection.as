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
	import net.vis4.map.MapMath;
	import net.vis4.map.proj.Projection;
	

	public class CylindricalEqualAreaProjection extends Projection
	{
		private var qp:Number;
		private var apa:Array;
		
		public function CylindricalEqualAreaProjection(projectionLatitude:Number = 0, projectionLongitude:Number = 0, trueScaleLatitude:Number = 0) 
		{
			
			this.projectionLatitude = projectionLatitude;
			this.projectionLongitude = projectionLongitude;
			this.trueScaleLatitude = trueScaleLatitude;
			initialize();
		}
		
		override public function initialize():void 
		{
			super.initialize();
			var t:Number = trueScaleLatitude;
			
			scaleFactor = Math.cos(t);
			if (es != 0) {
				t = Math.sin(t);
				scaleFactor /= Math.sqrt(1. - es * t * t);
				apa = MapMath.authset(es);
				qp = MapMath.qsfn(1., e, one_es);
			}
		}
		
		override public function project(lam:Number, phi:Number, xy:Point):Point 
		{
			if (spherical) {
				xy.x = scaleFactor * lam;
				xy.y = Math.sin(phi) / scaleFactor;
			} else {
				xy.x = scaleFactor * lam;
				xy.y = .5 * MapMath.qsfn(Math.sin(phi), e, one_es) / scaleFactor;
			}
			return xy;
		}
		
		override public function projectInverse(x:Number, y:Number, lp:Point):Point 
		{
			if (spherical) {
				var t:Number;

				if ((t = Math.abs(y *= scaleFactor)) - EPS10 <= 1.) {
					if (t >= 1.)
						lp.y = y < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
					else
						lp.y = Math.asin(y);
					lp.x = x / scaleFactor;
				} else throw new ProjectionError();
			} else {
				lp.y = MapMath.authlat(Math.asin( 2. * y * scaleFactor / qp), apa);
				lp.x = x / scaleFactor;
			}
			return lp;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function isRectilinear():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Cylindrical Equal Area";
		}
		
		override public function get shortName():String { return "Cylindrical"; }
		
	}

}