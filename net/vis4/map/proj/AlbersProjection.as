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

	public class AlbersProjection extends Projection
	{
		private static const EPS10:Number = 1.e-10;
		private static const TOL7:Number = 1.e-7;
		private var ec:Number;
		private var n:Number;
		private var c:Number;
		private var dd:Number;
		private var n2:Number;
		private var rho0:Number;
		private var phi1:Number;
		private var phi2:Number;
		private var en:Array;

		private static const N_ITER:int = 15;
		private static const EPSILON:Number = 1.0e-7;
		private static const TOL:Number = 1.0e-10;
		
		public function AlbersProjection() 
		{
			minLatitude = MapMath.toRadians(0);
			maxLatitude = MapMath.toRadians(80);
			projectionLatitude1 = MapMath.degToRad(75.5);
			projectionLatitude2 = MapMath.degToRad(29.5);	
			minLongitude = MapMath.toRadians( -135);
			maxLongitude = MapMath.toRadians( 135);
			initialize();
		}

		private static function phi1_(qs:Number, Te:Number, Tone_es:Number):Number 
		{
			var i:int;
			var Phi:Number, sinpi:Number, cospi:Number, con:Number, com:Number, dphi:Number;

			Phi = Math.asin (.5 * qs);
			if (Te < EPSILON)
				return( Phi );
			i = N_ITER;
			do {
				sinpi = Math.sin (Phi);
				cospi = Math.cos (Phi);
				con = Te * sinpi;
				com = 1. - con * con;
				dphi = .5 * com * com / cospi * (qs / Tone_es -
				   sinpi / com + .5 / Te * Math.log ((1. - con) /
				   (1. + con)));
				Phi += dphi;
			} while (Math.abs(dphi) > TOL && --i != 0);
			return( i != 0 ? Phi : Number.MAX_VALUE );
		}
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var rho:Number;
			if ((rho = c - (!spherical ? n * MapMath.qsfn(Math.sin(lpphi), e, one_es) : n2 * Math.sin(lpphi))) < 0.)
				throw new ProjectionError("F");
			rho = dd * Math.sqrt(rho);
			out.x = rho * Math.sin( lplam *= n );
			out.y = rho0 - rho * Math.cos(lplam);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var rho:Number;
			if ((rho = MapMath.distance(xyx, xyy = rho0 - xyy)) != 0) {
				var lpphi:Number, lplam:Number;
				if (n < 0.) {
					rho = -rho;
					xyx = -xyx;
					xyy = -xyy;
				}
				lpphi =  rho / dd;
				if (!spherical) {
					lpphi = (c - lpphi * lpphi) / n;
					if (Math.abs(ec - Math.abs(lpphi)) > TOL7) {
						if ((lpphi = phi1_(lpphi, e, one_es)) == Number.MAX_VALUE)
							throw new ProjectionError("I");
					} else
						lpphi = lpphi < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
				} else if (Math.abs(out.y = (c - lpphi * lpphi) / n2) <= 1.)
					lpphi = Math.asin(lpphi);
				else
					lpphi = lpphi < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
				lplam = Math.atan2(xyx, xyy) / n;
				out.x = lplam;
				out.y = lpphi;
			} else {
				out.x = 0.;
				out.y = n > 0. ? MapMath.HALFPI : - MapMath.HALFPI;
			}
			return out;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			var cosphi:Number, sinphi:Number;
			var secant:Boolean;

			phi1 = projectionLatitude1;
			phi2 = projectionLatitude2;

			if (Math.abs(phi1 + phi2) < EPS10)
				throw new ArgumentError("-21");
			n = sinphi = Math.sin(phi1);
			cosphi = Math.cos(phi1);
			secant = Math.abs(phi1 - phi2) >= EPS10;
			spherical = es > 0.0;
			if (!spherical) {
				var ml1:Number, m1:Number;

				if ((en = MapMath.enfn(es)) == null)
					throw new ArgumentError("0");
				m1 = MapMath.msfn(sinphi, cosphi, es);
				ml1 = MapMath.qsfn(sinphi, e, one_es);
				if (secant) { /* secant cone */
					var ml2:Number, m2:Number;

					sinphi = Math.sin(phi2);
					cosphi = Math.cos(phi2);
					m2 = MapMath.msfn(sinphi, cosphi, es);
					ml2 = MapMath.qsfn(sinphi, e, one_es);
					n = (m1 * m1 - m2 * m2) / (ml2 - ml1);
				}
				ec = 1. - .5 * one_es * Math.log((1. - e) /
					(1. + e)) / e;
				c = m1 * m1 + n * ml1;
				dd = 1. / n;
				rho0 = dd * Math.sqrt(c - n * MapMath.qsfn(Math.sin(projectionLatitude),
					e, one_es));
			} else {
				if (secant) n = .5 * (n + Math.sin(phi2));
				n2 = n + n;
				c = cosphi * cosphi + n2 * sinphi;
				dd = 1. / n;
				rho0 = dd * Math.sqrt(c - n2 * Math.sin(projectionLatitude));
			}			
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function isConformal():Boolean 
		{
			return true;
		}
		
		override public function getEPSGCode():int 
		{
			return 9822;
		}
		
		override public function toString():String 
		{
			return "Albers Equal Area";
		}
		
		override public function get shortName():String { return "Albers"; }
		override public function get inventor():String { return "Christian Albers"; }
		override public function get year():int { return 1805 ; }
		
	}

}