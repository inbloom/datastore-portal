/*
 * Copyright 2012 Shared Learning Collaborative, LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * SLC Portal developer
 */
var SLC = SLC || {},
	newJQuery = jQuery.noConflict(true),
	oldJQuery = jQuery;
SLC.developer = (function($) {

	// when user "Don't show this again" checkbox selects, "Apply" button will be displayed
	$(".action_checkbox").click(function (e) {
		if ($(this).is(':checked')) {
			$("#apply_button").css("display", "inline-block");
		}
		else {
			$("#apply_button").css("display", "none");
		}
	});

	// create a popover for the tasks
	$(".tasks").popover({
		trigger: 'hover',
		placement: 'right'
	});
}(newJQuery));