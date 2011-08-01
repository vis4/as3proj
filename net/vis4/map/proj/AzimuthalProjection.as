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
 * This file was manually ported to actionscript by Gregor Aisch, vis4.net
 */
package net.vis4.map.proj 
{
	import net.vis4.map.MapMath;
	import net.vis4.map.proj.Projection;
	
	/**
	 * The superclass for all azimuthal map projections
	 */
	public class AzimuthalProjection extends Projection
	{
		
		public static const NORTH_POLE:int = 1;
		public static const SOUTH_POLE:int = 2;
		public static const EQUATOR:int = 3;
		public static const OBLIQUE:int = 4;
		
		protected var mode:int;
		protected var sinphi0:Number, cosphi0:Number;
		private var mapRadius:Number = 90.0;
		
		public function AzimuthalProjection(projectionLatitude:* = null, projectionLongitude:* = null) {
			this.projectionLatitude = projectionLatitude != null ? projectionLatitude : MapMath.toRadians(45.0);
			this.projectionLongitude = projectionLongitude != null ? projectionLongitude : MapMath.toRadians(45.0);
			initialize();
		}
		
		override public function initialize():void {
			super.initialize();
			if (Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) < EPS10)
				mode = projectionLatitude < 0. ? SOUTH_POLE : NORTH_POLE;
			else if (Math.abs(projectionLatitude) > EPS10) {
				mode = OBLIQUE;
				sinphi0 = Math.sin(projectionLatitude);
				cosphi0 = Math.cos(projectionLatitude);
			} else
				mode = EQUATOR;
		}

		override public function inside(lon:Number, lat:Number):Boolean 
		{
			return MapMath.greatCircleDistance( MapMath.toRadians(lon), MapMath.toRadians(lat), projectionLongitude, projectionLatitude) < MapMath.toRadians(mapRadius);
		}
		
		/**
		 * Set the map radius (in degrees). 180 shows a hemisphere, 360 shows the whole globe.
		 */
		public function setMapRadius(mapRadius:Number):void {
			this.mapRadius = mapRadius;
		}

		public function getMapRadius():Number {
			return mapRadius;
		}
		
	}

}