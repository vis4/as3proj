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
	import net.vis4.map.proj.Projection;
	
	public class AiryProjection extends Projection
	{

		private var p_halfpi:Number;
		private var sinph0:Number;
		private var cosph0:Number;
		private var Cb:Number;
		private var mode:int;
		private var no_cut:Boolean = true;	/* do not cut at hemisphere limit */

		private static const EPS:Number = 1.e-10;
		private static const N_POLE:int = 0;
		private static const S_POLE:int = 1;
		private static const EQUIT:int = 2;
		private static const OBLIQ:int = 3;
		
		
		public function AiryProjection() 
		{
			minLatitude = MapMath.toRadians(-60);
			maxLatitude = MapMath.toRadians(60);
			minLongitude = MapMath.toRadians(-90);
			maxLongitude = MapMath.toRadians(90);
			initialize();			
		}
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var sinlam:Number, coslam:Number, cosphi:Number, sinphi:Number, t:Number, s:Number, Krho:Number, cosz:Number;

			sinlam = Math.sin(lplam);
			coslam = Math.cos(lplam);
			switch (mode) {
			case EQUIT:
			case OBLIQ:
				sinphi = Math.sin(lpphi);
				cosphi = Math.cos(lpphi);
				cosz = cosphi * coslam;
				if (mode == OBLIQ)
					cosz = sinph0 * sinphi + cosph0 * cosz;
				if (!no_cut && cosz < -EPS)
					throw new ProjectionError("F");
				s = 1. - cosz;
				if (Math.abs(s) > EPS) {
					t = 0.5 * (1. + cosz);
					Krho = -Math.log(t)/s - Cb / t;
				} else
					Krho = 0.5 - Cb;
				out.x = Krho * cosphi * sinlam;
				if (mode == OBLIQ)
					out.y = Krho * (cosph0 * sinphi -
						sinph0 * cosphi * coslam);
				else
					out.y = Krho * sinphi;
				break;
			case S_POLE:
			case N_POLE:
				out.y = Math.abs(p_halfpi - lpphi);
				if (!no_cut && (lpphi - EPS) > MapMath.HALFPI)
					throw new ProjectionError("F");
				if ((out.y *= 0.5) > EPS) {
					t = Math.tan(lpphi);
					Krho = -2.*(Math.log(Math.cos(lpphi)) / t + t * Cb);
					out.x = Krho * sinlam;
					out.y = Krho * coslam;
					if (mode == N_POLE)
						out.y = -out.y;
				} else
					out.x = out.y = 0.;
			}
			return out;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			var beta:Number = 0;

	//		no_cut = pj_param(params, "bno_cut").i;
	//		beta = 0.5 * (MapMath.HALFPI - pj_param(params, "rlat_b").f);
			no_cut = false;//FIXME
			beta = 0.5 * (MapMath.HALFPI - 0);//FIXME
			if (Math.abs(beta) < EPS)
				Cb = -0.5;
			else {
				Cb = 1./Math.tan(beta);
				Cb *= Cb * Math.log(Math.cos(beta));
			}
			if (Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) < EPS)
				if (projectionLatitude < 0.) {
					p_halfpi = -MapMath.HALFPI;
					mode = S_POLE;
				} else {
					p_halfpi =  MapMath.HALFPI;
					mode = N_POLE;
				}
			else {
				if (Math.abs(projectionLatitude) < EPS)
					mode = EQUIT;
				else {
					mode = OBLIQ;
					sinph0 = Math.sin(projectionLatitude);
					cosph0 = Math.cos(projectionLatitude);
				}
			}
		}
		
		override public function toString():String 
		{
			return "Airy's Minimum-Error Azimuthal";
		}
		
		override public function get shortName():String { return "Airy"; }
		override public function get inventor():String { return "Sir George Biddell Airy"; }
		override public function get year():int { return 1861; }
				
	}

}