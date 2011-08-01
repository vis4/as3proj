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
	
	public class MillerProjection extends CylindricalProjection
	{
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.x = lplam;
			out.y = Math.log(Math.tan(MapMath.QUARTERPI + lpphi * .4)) * 1.25;
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.x = xyx;
			out.y = 2.5 * (Math.atan(Math.exp(.8 * xyy)) - MapMath.QUARTERPI);
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Miller Cylindrical";
		}
		
		override public function get shortName():String { return "Miller"; }
		
	}

}