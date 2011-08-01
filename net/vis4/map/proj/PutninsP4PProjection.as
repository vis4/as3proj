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
	
	public class PutninsP4PProjection extends Projection
	{
		protected var C_x:Number;
		protected var C_y:Number;
	
		public function PutninsP4PProjection() 
		{
			C_x = 0.874038744;
			C_y = 3.883251825;
		}
		
		override public function project(lplam:Number, lpphi:Number, xy:Point):Point 
		{
			lpphi = MapMath.asin(0.883883476 * Math.sin(lpphi));
			xy.x = C_x * lplam * Math.cos(lpphi);
			xy.x /= Math.cos(lpphi *= 0.333333333333333);
			xy.y = C_y * Math.sin(lpphi);
			return xy;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, lp:Point):Point 
		{
			lp.y = MapMath.asin(xyy / C_y);
			lp.x = xyx * Math.cos(lp.y) / C_x;
			lp.y *= 3.;
			lp.x /= Math.cos(lp.y);
			lp.y = MapMath.asin(1.13137085 * Math.sin(lp.y));
			return lp;
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Putnins P'4";
		}
		
	}

}