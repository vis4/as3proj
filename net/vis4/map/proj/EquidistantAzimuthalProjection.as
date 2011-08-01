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
	import net.vis4.map.proj.AzimuthalProjection;
	
	public class EquidistantAzimuthalProjection extends AzimuthalProjection
	{
		
		private static const TOL:Number = 1.e-8;

		private var en:Array;
		private var M1:Number;
		private var N1:Number;
		private var Mp:Number;
		private var He:Number;
		private var G:Number;
		//private var sinphi0:Number, cosphi0:Number;
	
		public function EquidistantAzimuthalProjection() 
		{
			super(MapMath.toRadians(90.0), MapMath.toRadians(0.0));
			initialize();
		}
		
		override public function initialize():void 
		{
			super.initialize();
			if (Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) < EPS10) {
				mode = projectionLatitude < 0. ? SOUTH_POLE : NORTH_POLE;
				sinphi0 = projectionLatitude < 0. ? -1. : 1.;
				cosphi0 = 0.;
			} else if (Math.abs(projectionLatitude) < EPS10) {
				mode = EQUATOR;
				sinphi0 = 0.;
				cosphi0 = 1.;
			} else {
				mode = OBLIQUE;
				sinphi0 = Math.sin(projectionLatitude);
				cosphi0 = Math.cos(projectionLatitude);
			}
			if (!spherical) {
				en = MapMath.enfn(es);
				switch (mode) {
				case NORTH_POLE:
					Mp = MapMath.mlfn(MapMath.HALFPI, 1., 0., en);
					break;
				case SOUTH_POLE:
					Mp = MapMath.mlfn(-MapMath.HALFPI, -1., 0., en);
					break;
				case EQUATOR:
				case OBLIQUE:
					N1 = 1. / Math.sqrt(1. - es * sinphi0 * sinphi0);
					G = sinphi0 * (He = e / Math.sqrt(one_es));
					He *= cosphi0;
					break;
				}
			}
		}
		
		override public function project(lam:Number, phi:Number, xy:Point):Point 
		{
			if (spherical) {
				var coslam:Number, cosphi:Number, sinphi:Number;

				sinphi = Math.sin(phi);
				cosphi = Math.cos(phi);
				coslam = Math.cos(lam);
				switch (mode) {
				case EQUATOR:
				case OBLIQUE:
					if (mode == EQUATOR)
						xy.y = cosphi * coslam;
					else
						xy.y = sinphi0 * sinphi + cosphi0 * cosphi * coslam;
					if (Math.abs(Math.abs(xy.y) - 1.) < TOL)
						if (xy.y < 0.)
							throw new ProjectionError(); 
						else
							xy.x = xy.y = 0.;
					else {
						xy.y = Math.acos(xy.y);
						xy.y /= Math.sin(xy.y);
						xy.x = xy.y * cosphi * Math.sin(lam);
						xy.y *= (mode == EQUATOR) ? sinphi :
							cosphi0 * sinphi - sinphi0 * cosphi * coslam;
					}
					break;
				case NORTH_POLE:
					phi = -phi;
					coslam = -coslam;
				case SOUTH_POLE:
					if (Math.abs(phi - MapMath.HALFPI) < EPS10)
						throw new ProjectionError();
					xy.x = (xy.y = (MapMath.HALFPI + phi)) * Math.sin(lam);
					xy.y *= coslam;
					break;
				}
			} else {
				var rho:Number, s:Number, H:Number, H2:Number, c:Number, Az:Number, t:Number, ct:Number, st:Number, cA:Number, sA:Number;
			
				coslam = Math.cos(lam);
				cosphi = Math.cos(phi);
				sinphi = Math.sin(phi);
				switch (mode) {
				case NORTH_POLE:
					coslam = - coslam;
				case SOUTH_POLE:
					xy.x = (rho = Math.abs(Mp - MapMath.mlfn(phi, sinphi, cosphi, en))) *
						Math.sin(lam);
					xy.y = rho * coslam;
					break;
				case EQUATOR:
				case OBLIQUE:
					if (Math.abs(lam) < EPS10 && Math.abs(phi - projectionLatitude) < EPS10) {
						xy.x = xy.y = 0.;
						break;
					}
					t = Math.atan2(one_es * sinphi + es * N1 * sinphi0 *
						Math.sqrt(1. - es * sinphi * sinphi), cosphi);
					ct = Math.cos(t); st = Math.sin(t);
					Az = Math.atan2(Math.sin(lam) * ct, cosphi0 * st - sinphi0 * coslam * ct);
					cA = Math.cos(Az); sA = Math.sin(Az);
					s = MapMath.asin( Math.abs(sA) < TOL ?
						(cosphi0 * st - sinphi0 * coslam * ct) / cA :
						Math.sin(lam) * ct / sA );
					H = He * cA;
					H2 = H * H;
					c = N1 * s * (1. + s * s * (- H2 * (1. - H2)/6. +
						s * ( G * H * (1. - 2. * H2 * H2) / 8. +
						s * ((H2 * (4. - 7. * H2) - 3. * G * G * (1. - 7. * H2)) /
						120. - s * G * H / 48.))));
					xy.x = c * sA;
					xy.y = c * cA;
					break;
				}
			}
			return xy;
		}
		
		override public function projectInverse(x:Number, y:Number, lp:Point):Point 
		{
			if (spherical) {
				var cosc:Number, c_rh:Number, sinc:Number;

				if ((c_rh = MapMath.distance(x, y)) > Math.PI) {
					if (c_rh - EPS10 > Math.PI)
						throw new ProjectionError(); 
					c_rh = Math.PI;
				} else if (c_rh < EPS10) {
					lp.y = projectionLatitude;
					lp.x = 0.;
					return lp;
				}
				if (mode == OBLIQUE || mode == EQUATOR) {
					sinc = Math.sin(c_rh);
					cosc = Math.cos(c_rh);
					if (mode == EQUATOR) {
						lp.y = MapMath.asin(y * sinc / c_rh);
						x *= sinc;
						y = cosc * c_rh;
					} else {
						lp.y = MapMath.asin(cosc * sinphi0 + y * sinc * cosphi0 /
							c_rh);
						y = (cosc - sinphi0 * Math.sin(lp.y)) * c_rh;
						x *= sinc * cosphi0;
					}
					lp.x = y == 0. ? 0. : Math.atan2(x, y);
				} else if (mode == NORTH_POLE) {
					lp.y = MapMath.HALFPI - c_rh;
					lp.x = Math.atan2(x, -y);
				} else {
					lp.y = c_rh - MapMath.HALFPI;
					lp.x = Math.atan2(x, y);
				}
			} else {
				var c:Number, Az:Number, cosAz:Number, A:Number, B:Number, D:Number, E:Number, F:Number, psi:Number, t:Number;
				var i:int;

				if ((c = MapMath.distance(x, y)) < EPS10) {
					lp.y = projectionLatitude;
					lp.x = 0.;
					return (lp);
				}
				if (mode == OBLIQUE || mode == EQUATOR) {
					cosAz = Math.cos(Az = Math.atan2(x, y));
					t = cosphi0 * cosAz;
					B = es * t / one_es;
					A = - B * t;
					B *= 3. * (1. - A) * sinphi0;
					D = c / N1;
					E = D * (1. - D * D * (A * (1. + A) / 6. + B * (1. + 3.*A) * D / 24.));
					F = 1. - E * E * (A / 2. + B * E / 6.);
					psi = MapMath.asin(sinphi0 * Math.cos(E) + t * Math.sin(E));
					lp.x = MapMath.asin(Math.sin(Az) * Math.sin(E) / Math.cos(psi));
					if ((t = Math.abs(psi)) < EPS10)
						lp.y = 0.;
					else if (Math.abs(t - MapMath.HALFPI) < 0.)
						lp.y = MapMath.HALFPI;
					else
						lp.y = Math.atan((1. - es * F * sinphi0 / Math.sin(psi)) * Math.tan(psi) / one_es);
				} else {
					lp.y = MapMath.inv_mlfn(mode == NORTH_POLE ? Mp - c : Mp + c, es, en);
					lp.x = Math.atan2(x, mode == NORTH_POLE ? -y : y);
				}
			}
			return lp;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Equidistant Azimuthal";
		}
		
	}

}