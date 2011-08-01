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
	import net.vis4.map.proj.STSProjection;
	
	public class QuarticAuthalicProjection extends STSProjection
	{
		
		public function QuarticAuthalicProjection() 
		{
			super( 2., 2., false );
		}
		
		override public function toString():String 
		{
			return "Quartic Authalic";
		}
		
		override public function get shortName():String { return "Quartic"; }
		override public function get inventor():String { return "Karl Siemon"; }
		override public function get year():int { return 1937; }
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
	}

}