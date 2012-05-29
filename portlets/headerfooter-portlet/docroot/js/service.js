Liferay.Service.register("Liferay.Service.sli", "org.slc.sli.headerfooter.service", "headerfooter-portlet");

Liferay.Service.registerClass(
	Liferay.Service.sli, "HeaderFooter",
	{
		getHeader: true,
		getFooter: true
	}
);