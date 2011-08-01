/*
Copyright 2010 Gregor Aisch

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

package net.vis4.map.proj 
{
	import flash.geom.Point;
	
	public class GallPetersProjection extends Projection
	{
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.x = (a * lplam) / (Math.SQRT2);
			out.y =	(a * Math.SQRT2 * Math.sin(lpphi));
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.x = Math.SQRT2 * (xyx / a);
			out.y = Math.asin(xyy / Math.SQRT2 / a);
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		override public function isRectilinear():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Gall-Peters";
		}
		
	}

}