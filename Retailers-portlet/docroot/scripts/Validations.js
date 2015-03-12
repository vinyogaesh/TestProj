ko.extenders.validPackage = function(target, overrideMessage)
{
	// add some sub-observables to our observable
	target.hasError = ko.observable();

	// define a function to do validation
	function validate(newValue)
	{
		var regexp = /^[0-9]+(\'S)$/;
		var regExpMl=/^\d+(\.[0-9]{1,3})?(ML)$/;
		var regexpGm=/^\d+(\.[0-9]{1,3})?(GM)$/;
		var regexpMdi=/^\d+(MDI)$/;
		if (regexp.test(newValue)||regExpMl.test(newValue)||regexpGm.test(newValue)||regexpMdi.test(newValue))
		{
			target.hasError(false);
		} else
		{
			target.hasError(true);
		}

	}

	// initial validation
	validate(target());

	// validate whenever the value changes
	target.subscribe(validate);

	// return the original observable
	return target;
};
ko.extenders.validPrice = function(target, overrideMessage)
{
	// add some sub-observables to our observable
	target.hasError = ko.observable();

	// define a function to do validation
	function validate(newValue)
	{
		var regexp = /^[0-9]+(\.\d{1,2})?$/;
		if (regexp.test(newValue))
		{
			target.hasError(false);
		} else
		{
			target.hasError(true);
		}

	}

	// initial validation
	validate(target());

	// validate whenever the value changes
	target.subscribe(validate);

	// return the original observable
	return target;
};