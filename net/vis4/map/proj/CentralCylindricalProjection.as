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
	import net.vis4.map.proj.CylindricalProjection;

	/**
	 * ...
	 * @author gka
	 */
	public class CentralCylindricalProjection extends CylindricalProjection
	{
		private var ap:Number;

		private static const EPS10:Number = 1.e-10;

		public function CentralCylindricalProjection()
		{
			minLatitude = MapMath.degToRad(-78);
			maxLatitude = MapMath.degToRad(83);
		}

		override public function project(lplam:Number, lpphi:Number, out:Point):Point
		{
			if (Math.abs(Math.abs(lpphi) - MapMath.HALFPI) <= EPS10) throw new ProjectionError("F");
			out.x = lplam;
			out.y = Math.tan(lpphi);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.y = Math.atan(xyy);
			out.x = xyx;
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Central Cylindrical";
		}
		
		override public function get shortName():String { return "Central"; }
	}

}

