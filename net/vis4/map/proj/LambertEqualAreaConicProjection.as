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
	import net.vis4.map.MapMath;
	import net.vis4.map.proj.AlbersProjection;
	
	public class LambertEqualAreaConicProjection extends AlbersProjection
	{
		
		public function LambertEqualAreaConicProjection(south:Boolean = false) 
		{
			minLatitude = MapMath.toRadians(0);
			maxLatitude = MapMath.toRadians(90);
			projectionLatitude1 = south ? -MapMath.QUARTERPI : MapMath.QUARTERPI;
			projectionLatitude2 = south ? -MapMath.HALFPI : MapMath.HALFPI;
			initialize();
		}
		
		override public function toString():String 
		{
			return "Lambert Equal Area Conic";
		}
		
		override public function get shortName():String { return "Lambert II"; }
				
	}

}