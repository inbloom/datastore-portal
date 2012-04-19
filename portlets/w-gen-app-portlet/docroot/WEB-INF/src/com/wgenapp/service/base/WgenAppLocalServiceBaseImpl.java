/**
 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.wgenapp.service.base;

import com.liferay.counter.service.CounterLocalService;

import com.liferay.portal.kernel.bean.BeanReference;
import com.liferay.portal.kernel.bean.IdentifiableBean;
import com.liferay.portal.kernel.dao.jdbc.SqlUpdate;
import com.liferay.portal.kernel.dao.jdbc.SqlUpdateFactoryUtil;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.search.Indexer;
import com.liferay.portal.kernel.search.IndexerRegistryUtil;
import com.liferay.portal.kernel.search.SearchException;
import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.model.PersistedModel;
import com.liferay.portal.service.PersistedModelLocalServiceRegistryUtil;
import com.liferay.portal.service.ResourceLocalService;
import com.liferay.portal.service.ResourceService;
import com.liferay.portal.service.UserLocalService;
import com.liferay.portal.service.UserService;
import com.liferay.portal.service.persistence.ResourcePersistence;
import com.liferay.portal.service.persistence.UserPersistence;

import com.wgenapp.model.WgenApp;

import com.wgenapp.service.WgenAppLocalService;
import com.wgenapp.service.WgenAppService;
import com.wgenapp.service.persistence.WgenAppPersistence;

import java.io.Serializable;

import java.util.List;

import javax.sql.DataSource;

/**
 * The base implementation of the wgen app local service.
 *
 * <p>
 * This implementation exists only as a container for the default service methods generated by ServiceBuilder. All custom service methods should be put in {@link com.wgenapp.service.impl.WgenAppLocalServiceImpl}.
 * </p>
 *
 * @author Brian Wing Shun Chan
 * @see com.wgenapp.service.impl.WgenAppLocalServiceImpl
 * @see com.wgenapp.service.WgenAppLocalServiceUtil
 * @generated
 */
public abstract class WgenAppLocalServiceBaseImpl implements WgenAppLocalService,
	IdentifiableBean {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never modify or reference this class directly. Always use {@link com.wgenapp.service.WgenAppLocalServiceUtil} to access the wgen app local service.
	 */

	/**
	 * Adds the wgen app to the database. Also notifies the appropriate model listeners.
	 *
	 * @param wgenApp the wgen app
	 * @return the wgen app that was added
	 * @throws SystemException if a system exception occurred
	 */
	public WgenApp addWgenApp(WgenApp wgenApp) throws SystemException {
		wgenApp.setNew(true);

		wgenApp = wgenAppPersistence.update(wgenApp, false);

		Indexer indexer = IndexerRegistryUtil.getIndexer(getModelClassName());

		if (indexer != null) {
			try {
				indexer.reindex(wgenApp);
			}
			catch (SearchException se) {
				if (_log.isWarnEnabled()) {
					_log.warn(se, se);
				}
			}
		}

		return wgenApp;
	}

	/**
	 * Creates a new wgen app with the primary key. Does not add the wgen app to the database.
	 *
	 * @param WgenAppId the primary key for the new wgen app
	 * @return the new wgen app
	 */
	public WgenApp createWgenApp(long WgenAppId) {
		return wgenAppPersistence.create(WgenAppId);
	}

	/**
	 * Deletes the wgen app with the primary key from the database. Also notifies the appropriate model listeners.
	 *
	 * @param WgenAppId the primary key of the wgen app
	 * @throws PortalException if a wgen app with the primary key could not be found
	 * @throws SystemException if a system exception occurred
	 */
	public void deleteWgenApp(long WgenAppId)
		throws PortalException, SystemException {
		WgenApp wgenApp = wgenAppPersistence.remove(WgenAppId);

		Indexer indexer = IndexerRegistryUtil.getIndexer(getModelClassName());

		if (indexer != null) {
			try {
				indexer.delete(wgenApp);
			}
			catch (SearchException se) {
				if (_log.isWarnEnabled()) {
					_log.warn(se, se);
				}
			}
		}
	}

	/**
	 * Deletes the wgen app from the database. Also notifies the appropriate model listeners.
	 *
	 * @param wgenApp the wgen app
	 * @throws SystemException if a system exception occurred
	 */
	public void deleteWgenApp(WgenApp wgenApp) throws SystemException {
		wgenAppPersistence.remove(wgenApp);

		Indexer indexer = IndexerRegistryUtil.getIndexer(getModelClassName());

		if (indexer != null) {
			try {
				indexer.delete(wgenApp);
			}
			catch (SearchException se) {
				if (_log.isWarnEnabled()) {
					_log.warn(se, se);
				}
			}
		}
	}

	/**
	 * Performs a dynamic query on the database and returns the matching rows.
	 *
	 * @param dynamicQuery the dynamic query
	 * @return the matching rows
	 * @throws SystemException if a system exception occurred
	 */
	@SuppressWarnings("rawtypes")
	public List dynamicQuery(DynamicQuery dynamicQuery)
		throws SystemException {
		return wgenAppPersistence.findWithDynamicQuery(dynamicQuery);
	}

	/**
	 * Performs a dynamic query on the database and returns a range of the matching rows.
	 *
	 * <p>
	 * Useful when paginating results. Returns a maximum of <code>end - start</code> instances. <code>start</code> and <code>end</code> are not primary keys, they are indexes in the result set. Thus, <code>0</code> refers to the first result in the set. Setting both <code>start</code> and <code>end</code> to {@link com.liferay.portal.kernel.dao.orm.QueryUtil#ALL_POS} will return the full result set.
	 * </p>
	 *
	 * @param dynamicQuery the dynamic query
	 * @param start the lower bound of the range of model instances
	 * @param end the upper bound of the range of model instances (not inclusive)
	 * @return the range of matching rows
	 * @throws SystemException if a system exception occurred
	 */
	@SuppressWarnings("rawtypes")
	public List dynamicQuery(DynamicQuery dynamicQuery, int start, int end)
		throws SystemException {
		return wgenAppPersistence.findWithDynamicQuery(dynamicQuery, start, end);
	}

	/**
	 * Performs a dynamic query on the database and returns an ordered range of the matching rows.
	 *
	 * <p>
	 * Useful when paginating results. Returns a maximum of <code>end - start</code> instances. <code>start</code> and <code>end</code> are not primary keys, they are indexes in the result set. Thus, <code>0</code> refers to the first result in the set. Setting both <code>start</code> and <code>end</code> to {@link com.liferay.portal.kernel.dao.orm.QueryUtil#ALL_POS} will return the full result set.
	 * </p>
	 *
	 * @param dynamicQuery the dynamic query
	 * @param start the lower bound of the range of model instances
	 * @param end the upper bound of the range of model instances (not inclusive)
	 * @param orderByComparator the comparator to order the results by (optionally <code>null</code>)
	 * @return the ordered range of matching rows
	 * @throws SystemException if a system exception occurred
	 */
	@SuppressWarnings("rawtypes")
	public List dynamicQuery(DynamicQuery dynamicQuery, int start, int end,
		OrderByComparator orderByComparator) throws SystemException {
		return wgenAppPersistence.findWithDynamicQuery(dynamicQuery, start,
			end, orderByComparator);
	}

	/**
	 * Returns the number of rows that match the dynamic query.
	 *
	 * @param dynamicQuery the dynamic query
	 * @return the number of rows that match the dynamic query
	 * @throws SystemException if a system exception occurred
	 */
	public long dynamicQueryCount(DynamicQuery dynamicQuery)
		throws SystemException {
		return wgenAppPersistence.countWithDynamicQuery(dynamicQuery);
	}

	public WgenApp fetchWgenApp(long WgenAppId) throws SystemException {
		return wgenAppPersistence.fetchByPrimaryKey(WgenAppId);
	}

	/**
	 * Returns the wgen app with the primary key.
	 *
	 * @param WgenAppId the primary key of the wgen app
	 * @return the wgen app
	 * @throws PortalException if a wgen app with the primary key could not be found
	 * @throws SystemException if a system exception occurred
	 */
	public WgenApp getWgenApp(long WgenAppId)
		throws PortalException, SystemException {
		return wgenAppPersistence.findByPrimaryKey(WgenAppId);
	}

	public PersistedModel getPersistedModel(Serializable primaryKeyObj)
		throws PortalException, SystemException {
		return wgenAppPersistence.findByPrimaryKey(primaryKeyObj);
	}

	/**
	 * Returns a range of all the wgen apps.
	 *
	 * <p>
	 * Useful when paginating results. Returns a maximum of <code>end - start</code> instances. <code>start</code> and <code>end</code> are not primary keys, they are indexes in the result set. Thus, <code>0</code> refers to the first result in the set. Setting both <code>start</code> and <code>end</code> to {@link com.liferay.portal.kernel.dao.orm.QueryUtil#ALL_POS} will return the full result set.
	 * </p>
	 *
	 * @param start the lower bound of the range of wgen apps
	 * @param end the upper bound of the range of wgen apps (not inclusive)
	 * @return the range of wgen apps
	 * @throws SystemException if a system exception occurred
	 */
	public List<WgenApp> getWgenApps(int start, int end)
		throws SystemException {
		return wgenAppPersistence.findAll(start, end);
	}

	/**
	 * Returns the number of wgen apps.
	 *
	 * @return the number of wgen apps
	 * @throws SystemException if a system exception occurred
	 */
	public int getWgenAppsCount() throws SystemException {
		return wgenAppPersistence.countAll();
	}

	/**
	 * Updates the wgen app in the database or adds it if it does not yet exist. Also notifies the appropriate model listeners.
	 *
	 * @param wgenApp the wgen app
	 * @return the wgen app that was updated
	 * @throws SystemException if a system exception occurred
	 */
	public WgenApp updateWgenApp(WgenApp wgenApp) throws SystemException {
		return updateWgenApp(wgenApp, true);
	}

	/**
	 * Updates the wgen app in the database or adds it if it does not yet exist. Also notifies the appropriate model listeners.
	 *
	 * @param wgenApp the wgen app
	 * @param merge whether to merge the wgen app with the current session. See {@link com.liferay.portal.service.persistence.BatchSession#update(com.liferay.portal.kernel.dao.orm.Session, com.liferay.portal.model.BaseModel, boolean)} for an explanation.
	 * @return the wgen app that was updated
	 * @throws SystemException if a system exception occurred
	 */
	public WgenApp updateWgenApp(WgenApp wgenApp, boolean merge)
		throws SystemException {
		wgenApp.setNew(false);

		wgenApp = wgenAppPersistence.update(wgenApp, merge);

		Indexer indexer = IndexerRegistryUtil.getIndexer(getModelClassName());

		if (indexer != null) {
			try {
				indexer.reindex(wgenApp);
			}
			catch (SearchException se) {
				if (_log.isWarnEnabled()) {
					_log.warn(se, se);
				}
			}
		}

		return wgenApp;
	}

	/**
	 * Returns the wgen app local service.
	 *
	 * @return the wgen app local service
	 */
	public WgenAppLocalService getWgenAppLocalService() {
		return wgenAppLocalService;
	}

	/**
	 * Sets the wgen app local service.
	 *
	 * @param wgenAppLocalService the wgen app local service
	 */
	public void setWgenAppLocalService(WgenAppLocalService wgenAppLocalService) {
		this.wgenAppLocalService = wgenAppLocalService;
	}

	/**
	 * Returns the wgen app remote service.
	 *
	 * @return the wgen app remote service
	 */
	public WgenAppService getWgenAppService() {
		return wgenAppService;
	}

	/**
	 * Sets the wgen app remote service.
	 *
	 * @param wgenAppService the wgen app remote service
	 */
	public void setWgenAppService(WgenAppService wgenAppService) {
		this.wgenAppService = wgenAppService;
	}

	/**
	 * Returns the wgen app persistence.
	 *
	 * @return the wgen app persistence
	 */
	public WgenAppPersistence getWgenAppPersistence() {
		return wgenAppPersistence;
	}

	/**
	 * Sets the wgen app persistence.
	 *
	 * @param wgenAppPersistence the wgen app persistence
	 */
	public void setWgenAppPersistence(WgenAppPersistence wgenAppPersistence) {
		this.wgenAppPersistence = wgenAppPersistence;
	}

	/**
	 * Returns the counter local service.
	 *
	 * @return the counter local service
	 */
	public CounterLocalService getCounterLocalService() {
		return counterLocalService;
	}

	/**
	 * Sets the counter local service.
	 *
	 * @param counterLocalService the counter local service
	 */
	public void setCounterLocalService(CounterLocalService counterLocalService) {
		this.counterLocalService = counterLocalService;
	}

	/**
	 * Returns the resource local service.
	 *
	 * @return the resource local service
	 */
	public ResourceLocalService getResourceLocalService() {
		return resourceLocalService;
	}

	/**
	 * Sets the resource local service.
	 *
	 * @param resourceLocalService the resource local service
	 */
	public void setResourceLocalService(
		ResourceLocalService resourceLocalService) {
		this.resourceLocalService = resourceLocalService;
	}

	/**
	 * Returns the resource remote service.
	 *
	 * @return the resource remote service
	 */
	public ResourceService getResourceService() {
		return resourceService;
	}

	/**
	 * Sets the resource remote service.
	 *
	 * @param resourceService the resource remote service
	 */
	public void setResourceService(ResourceService resourceService) {
		this.resourceService = resourceService;
	}

	/**
	 * Returns the resource persistence.
	 *
	 * @return the resource persistence
	 */
	public ResourcePersistence getResourcePersistence() {
		return resourcePersistence;
	}

	/**
	 * Sets the resource persistence.
	 *
	 * @param resourcePersistence the resource persistence
	 */
	public void setResourcePersistence(ResourcePersistence resourcePersistence) {
		this.resourcePersistence = resourcePersistence;
	}

	/**
	 * Returns the user local service.
	 *
	 * @return the user local service
	 */
	public UserLocalService getUserLocalService() {
		return userLocalService;
	}

	/**
	 * Sets the user local service.
	 *
	 * @param userLocalService the user local service
	 */
	public void setUserLocalService(UserLocalService userLocalService) {
		this.userLocalService = userLocalService;
	}

	/**
	 * Returns the user remote service.
	 *
	 * @return the user remote service
	 */
	public UserService getUserService() {
		return userService;
	}

	/**
	 * Sets the user remote service.
	 *
	 * @param userService the user remote service
	 */
	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	/**
	 * Returns the user persistence.
	 *
	 * @return the user persistence
	 */
	public UserPersistence getUserPersistence() {
		return userPersistence;
	}

	/**
	 * Sets the user persistence.
	 *
	 * @param userPersistence the user persistence
	 */
	public void setUserPersistence(UserPersistence userPersistence) {
		this.userPersistence = userPersistence;
	}

	public void afterPropertiesSet() {
		PersistedModelLocalServiceRegistryUtil.register("com.wgenapp.model.WgenApp",
			wgenAppLocalService);
	}

	public void destroy() {
		PersistedModelLocalServiceRegistryUtil.unregister(
			"com.wgenapp.model.WgenApp");
	}

	/**
	 * Returns the Spring bean ID for this bean.
	 *
	 * @return the Spring bean ID for this bean
	 */
	public String getBeanIdentifier() {
		return _beanIdentifier;
	}

	/**
	 * Sets the Spring bean ID for this bean.
	 *
	 * @param beanIdentifier the Spring bean ID for this bean
	 */
	public void setBeanIdentifier(String beanIdentifier) {
		_beanIdentifier = beanIdentifier;
	}

	protected Class<?> getModelClass() {
		return WgenApp.class;
	}

	protected String getModelClassName() {
		return WgenApp.class.getName();
	}

	/**
	 * Performs an SQL query.
	 *
	 * @param sql the sql query
	 */
	protected void runSQL(String sql) throws SystemException {
		try {
			DataSource dataSource = wgenAppPersistence.getDataSource();

			SqlUpdate sqlUpdate = SqlUpdateFactoryUtil.getSqlUpdate(dataSource,
					sql, new int[0]);

			sqlUpdate.update();
		}
		catch (Exception e) {
			throw new SystemException(e);
		}
	}

	@BeanReference(type = WgenAppLocalService.class)
	protected WgenAppLocalService wgenAppLocalService;
	@BeanReference(type = WgenAppService.class)
	protected WgenAppService wgenAppService;
	@BeanReference(type = WgenAppPersistence.class)
	protected WgenAppPersistence wgenAppPersistence;
	@BeanReference(type = CounterLocalService.class)
	protected CounterLocalService counterLocalService;
	@BeanReference(type = ResourceLocalService.class)
	protected ResourceLocalService resourceLocalService;
	@BeanReference(type = ResourceService.class)
	protected ResourceService resourceService;
	@BeanReference(type = ResourcePersistence.class)
	protected ResourcePersistence resourcePersistence;
	@BeanReference(type = UserLocalService.class)
	protected UserLocalService userLocalService;
	@BeanReference(type = UserService.class)
	protected UserService userService;
	@BeanReference(type = UserPersistence.class)
	protected UserPersistence userPersistence;
	private static Log _log = LogFactoryUtil.getLog(WgenAppLocalServiceBaseImpl.class);
	private String _beanIdentifier;
}