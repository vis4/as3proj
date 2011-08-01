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
	
	public class SinusoidalProjection extends PseudoCylindricalProjection
	{
		
		override public function project(lam:Number, phi:Number, xy:Point):Point 
		{
			xy.x = lam * Math.cos(phi);
			xy.y = phi;
			return xy;
		}
		
		override public function projectInverse(x:Number, y:Number, lp:Point):Point 
		{
			lp.x = x / Math.cos(y);
			lp.y = y;
			return lp;
		}
		
		public function getWidth(y:Number):Number
		{
			return MapMath.normalizeLongitude(Math.PI) * Math.cos(y);
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
			return "Sinusoidal";
		}
		
	}

}

