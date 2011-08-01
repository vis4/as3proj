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
	
	public class TCCProjection extends CylindricalProjection
	{
		
		public function TCCProjection() 
		{
			minLongitude = MapMath.degToRad(-60);
			maxLongitude = MapMath.degToRad(60);
		}
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var b:Number, bt:Number;
	
			b = Math.cos(lpphi) * Math.sin(lplam);
			if ((bt = 1. - b * b) < EPS10)
				throw new ProjectionError("F");
			out.x = b / Math.sqrt(bt);
			out.y = Math.atan2(Math.tan(lpphi), Math.cos(lplam));
			return out;
		}
		
		override public function isRectilinear():Boolean 
		{
			return false;
		}
		
		override public function toString():String 
		{
			return "Transverse Central Cylindrical";
		}
		
		override public function get shortName():String { return "TCC"; }
		
		
	}

}