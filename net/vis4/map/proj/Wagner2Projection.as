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
	
	public class Wagner2Projection extends Projection
	{
		private static const C_x:Number = 0.92483;
		private static const C_y:Number = 1.38725;
		private static const C_p1:Number = 0.88022;
		private static const C_p2:Number = 0.88550;
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.y = MapMath.asin(C_p1 * Math.sin(C_p2 * lpphi));
			out.x = C_x * lplam * Math.cos(lpphi);
			out.y = C_y * lpphi;
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.y = xyy / C_y;
			out.x = xyx / (C_x * Math.cos(out.y));
			out.y = MapMath.asin(Math.sin(out.y) / C_p1) / C_p2;
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Wagner II";
		}
		
	}

}