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
 * manually ported to ActionScript by Gregor Aisch, vis4.net, 2010
 */

package net.vis4.map.proj 
{
	import flash.geom.Point;
	import net.vis4.map.MapMath;
	public class MBTFPPProjection extends Projection
	{
		private static const CS:Number = .95257934441568037152;
		private static const FXC:Number = .92582009977255146156;
		private static const FYC:Number = 3.40168025708304504493;
		private static const C23:Number = .66666666666666666666;
		private static const C13:Number = .33333333333333333333;
		private static const ONEEPS:Number = 1.0000001;
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.y = Math.asin(CS * Math.sin(lpphi));
			out.x = FXC * lplam * (2. * Math.cos(C23 * lpphi) - 1.);
			out.y = FYC * Math.sin(C13 * lpphi);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.y = xyy / FYC;
			if (Math.abs(out.y) >= 1.) {
				if (Math.abs(out.y) > ONEEPS)	throw new ProjectionError("I");
				else	out.y = (out.y < 0.) ? -MapMath.HALFPI : MapMath.HALFPI;
			} else
				out.y = Math.asin(out.y);
			out.x = xyx / ( FXC * (2. * Math.cos(C23 * (out.y *= 3.)) - 1.) );
			if (Math.abs(out.y = Math.sin(out.y) / CS) >= 1.) {
				if (Math.abs(out.y) > ONEEPS)	throw new ProjectionError("I");
				else	out.y = (out.y < 0.) ? -MapMath.HALFPI : MapMath.HALFPI;
			} else
				out.y = Math.asin(out.y);
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "McBride-Thomas Flat-Polar Parabolic";
		}
		
		override public function get shortName():String { return "MBTFPP"; }
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
	}

}