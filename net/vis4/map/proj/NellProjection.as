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
	
	public class NellProjection extends Projection
	{
		private static const MAX_ITER:int = 10;
		private static const LOOP_TOL:Number = 1e-7;
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var k:Number, d:Number, x:Number, i:int;
			
			//rho + Math.sin(rho) = 2 * Math.sin(lpphi);
						
			k = 2. * Math.sin(lpphi);
			
			x = .34;
			
			for (i = MAX_ITER; i > 0 ; --i) {
				x = x - (x + Math.sin(x) - k) / (1 + Math.cos(x)); // thanks to newton
				d = (x + Math.sin(x) - k);// calc difference
				if (Math.abs(d) < LOOP_TOL)	break;
			}
			out.x = 0.5 * lplam * (1. + Math.cos(lpphi));
			out.y = x;
			
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var th:Number, s:Number; // unneeded vars?

			out.x = 2. * xyx / (1. + Math.cos(xyy));
			out.y = MapMath.asin(0.5 * (xyy + Math.sin(xyy)));
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Nell";
		}
		
		override public function get inventor():String { return "A.M. Nell"; }
		override public function get year():int { return 1890; }
		
	}

}