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
	import net.vis4.map.proj.PseudoCylindricalProjection;
	
	public class BoggsProjection extends PseudoCylindricalProjection
	{
		
		private static const NITER:int = 20;
		private static const EPS:Number = 1e-7;
		private static const ONETOL:Number = 1.000001;
		private static const FXC:Number = 2.00276;
		private static const FXC2:Number = 1.11072;
		private static const FYC:Number = 0.49931;
		private static const FYC2:Number = 1.41421356237309504880;
	
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var theta:Number, th1:Number, c:Number;
			var i:int;

			theta = lpphi;
			if (Math.abs(Math.abs(lpphi) - MapMath.HALFPI) < EPS)
				out.x = 0.;
			else {
				c = Math.sin(theta) * Math.PI;
				for (i = NITER; i > 0; --i) {
					theta -= th1 = (theta + Math.sin(theta) - c) /
						(1. + Math.cos(theta));
					if (Math.abs(th1) < EPS) break;
				}
				theta *= 0.5;
				out.x = FXC * lplam / (1. / Math.cos(lpphi) + FXC2 / Math.cos(theta));
			}
			out.y = FYC * (lpphi + FYC2 * Math.sin(theta));
			return out;			
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		override public function hasInverse():Boolean 
		{
			return false;
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Boggs Eumorphic";
		}
		
		override public function get shortName():String { return "Boggs"; }
		
	}

}