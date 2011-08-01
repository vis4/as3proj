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
	
	public class GoodeProjection extends PseudoCylindricalProjection
	{
		private static const Y_COR:Number = 0.05280;
		private static const PHI_LIM:Number = .71093078197902358062;
	
		private var sinu:SinusoidalProjection = new SinusoidalProjection();
		private var moll:MollweideProjection = new MollweideProjection();
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			if (Math.abs(lpphi) <= PHI_LIM)
				out = sinu.project(lplam, lpphi, out);
			else {
				out = moll.project(lplam, lpphi, out);
				out.y -= lpphi >= 0.0 ? Y_COR : -Y_COR;
			}
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			if (Math.abs(xyy) <= PHI_LIM)
				out = sinu.projectInverse(xyx, xyy, out);
			else {
				xyy += xyy >= 0.0 ? Y_COR : -Y_COR;
				out = moll.projectInverse(xyx, xyy, out);
			}
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Goode Homolosine";
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		override public function get shortName():String { return "Goode"; }
		
		
		
	}

}