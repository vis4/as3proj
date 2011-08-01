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
	
	public class MercatorProjection extends CylindricalProjection
	{
		
		public function MercatorProjection() 
		{
			minLatitude = MapMath.degToRad(-78);
			maxLatitude = MapMath.degToRad(83);
		}
		
		override public function project(lam:Number, phi:Number, out:Point):Point 
		{
			if (spherical) {
				out.x = scaleFactor * lam;
				out.y = scaleFactor * Math.log(Math.tan(MapMath.QUARTERPI + 0.5 * phi));
			} else {
				out.x = scaleFactor * lam;
				out.y = -scaleFactor * Math.log(MapMath.tsfn(phi, Math.sin(phi), e));
			}
			return out;
		}
		
		override public function projectInverse(x:Number, y:Number, out:Point):Point 
		{
			if (spherical) {
				out.y = MapMath.HALFPI - 2. * Math.atan(Math.exp(-y / scaleFactor));
				out.x = x / scaleFactor;
			} else {
				out.y = MapMath.phi2(Math.exp(-y / scaleFactor), e);
				out.x = x / scaleFactor;
			}
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function isRectilinear():Boolean 
		{
			return true;
		}
		
		override public function getEPSGCode():int 
		{
			return 9804;
		}
		
		override public function toString():String 
		{
			return "Mercator";
		}
	}

}