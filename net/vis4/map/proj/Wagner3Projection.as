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

	public class Wagner3Projection extends PseudoCylindricalProjection
	{
		private static const TWOTHIRD:Number = 0.6666666666666666666667;

		private var C_x:Number;
		
		override public function project(lplam:Number, lpphi:Number, xy:Point):Point 
		{
			xy.x = C_x * lplam * Math.cos(TWOTHIRD * lpphi);
			xy.y = lpphi;
			return xy;
		}
		
		override public function projectInverse(x:Number, y:Number, lp:Point):Point 
		{
			lp.y = y;
			lp.x = x / (C_x * Math.cos(TWOTHIRD * lp.y));
			return lp;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			C_x = Math.cos(trueScaleLatitude) / Math.cos(2.*trueScaleLatitude/3.);
			es = 0.;
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
			return "Wagner III";
		}
		
	}

}