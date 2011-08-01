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
	
	public class HatanoProjection extends Projection
	{
		private static const NITER:int = 20;
		private static const EPS:Number = 1e-7;
		private static const ONETOL:Number = 1.000001;
		private static const CN:Number = 2.67595;
		private static const CS:Number = 2.43763;
		private static const RCN:Number = 0.37369906014686373063;
		private static const RCS:Number = 0.41023453108141924738;
		private static const FYCN:Number = 1.75859;
		private static const FYCS:Number = 1.93052;
		private static const RYCN:Number = 0.56863737426006061674;
		private static const RYCS:Number = 0.51799515156538134803;
		private static const FXC:Number = 0.85;
		private static const RXC:Number = 1.17647058823529411764;
	
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var th1:Number, c:Number, i:int;
			
			c = Math.sin(lpphi) * (lpphi < 0. ? CS : CN);
			for (i = NITER; i > 0; --i) {
				lpphi -= th1 = (lpphi + Math.sin(lpphi) - c) / (1. + Math.cos(lpphi));
				if (Math.abs(th1) < EPS) break;
			}
			out.x = FXC * lplam * Math.cos(lpphi *= .5);
			out.y = Math.sin(lpphi) * (lpphi < 0. ? FYCS : FYCN);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var th:Number;

			th = xyy * ( xyy < 0. ? RYCS : RYCN);
			if (Math.abs(th) > 1.)
				if (Math.abs(th) > ONETOL)	throw new ProjectionError("I");
				else			th = th > 0. ? MapMath.HALFPI : - MapMath.HALFPI;
			else
				th = Math.asin(th);
			out.x = RXC * xyx / Math.cos(th);
			th += th;
			out.y = (th + Math.sin(th)) * (xyy < 0. ? RCS : RCN);
			if (Math.abs(out.y) > 1.)
				if (Math.abs(out.y) > ONETOL)	throw new ProjectionError("I");
				else			out.y = out.y > 0. ? MapMath.HALFPI : - MapMath.HALFPI;
			else
				out.y = Math.asin(out.y);
			return out;
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
			return "Hatano Asymmetrical Equal Area";
		}
		
		override public function get shortName():String { return "Hatano"; }
		
	}

}