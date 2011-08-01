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
	
	public class LarriveeProjection extends Projection
	{
		private static const SIXTH:Number = .16666666666666666;
		
		public function LarriveeProjection() 
		{
			minLatitude = MapMath.degToRad(-85);
			maxLatitude = MapMath.degToRad(85);
		}
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			//out.x = 0.5 * lplam * (1. + Math.sqrt(Math.cos(lpphi)));
			//out.y = lpphi / (Math.cos(0.5 * lpphi) * Math.cos(SIXTH * lplam));
			out.x = (.5 + .5 * Math.sqrt(Math.cos(lpphi))) * lplam;
			out.y = lpphi / (Math.cos(.5 * lpphi) * Math.cos(SIXTH * lplam));
			return out;
		}
		
		override public function toString():String 
		{
			return "Larrivée";
		}
		
		override public function get inventor():String { return "Léo Larrivée"; }
		override public function get year():int { return 1988; }
			
	}

}