/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
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

package org.slc.sli.headerfooter.model;

import com.liferay.portal.kernel.bean.AutoEscape;
import com.liferay.portal.model.BaseModel;
import com.liferay.portal.model.CacheModel;
import com.liferay.portal.service.ServiceContext;

import com.liferay.portlet.expando.model.ExpandoBridge;

import java.io.Serializable;

/**
 * The base model interface for the HeaderFooter service. Represents a row in the &quot;sli_HeaderFooter&quot; database table, with each column mapped to a property of this class.
 *
 * <p>
 * This interface and its corresponding implementation {@link org.slc.sli.headerfooter.model.impl.HeaderFooterModelImpl} exist only as a container for the default property accessors generated by ServiceBuilder. Helper methods and all application logic should be put in {@link org.slc.sli.headerfooter.model.impl.HeaderFooterImpl}.
 * </p>
 *
 * @author manoj
 * @see HeaderFooter
 * @see org.slc.sli.headerfooter.model.impl.HeaderFooterImpl
 * @see org.slc.sli.headerfooter.model.impl.HeaderFooterModelImpl
 * @generated
 */
public interface HeaderFooterModel extends BaseModel<HeaderFooter> {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never modify or reference this interface directly. All methods that expect a header footer model instance should use the {@link HeaderFooter} interface instead.
	 */

	/**
	 * Returns the primary key of this header footer.
	 *
	 * @return the primary key of this header footer
	 */
	public long getPrimaryKey();

	/**
	 * Sets the primary key of this header footer.
	 *
	 * @param primaryKey the primary key of this header footer
	 */
	public void setPrimaryKey(long primaryKey);

	/**
	 * Returns the ID of this header footer.
	 *
	 * @return the ID of this header footer
	 */
	public long getId();

	/**
	 * Sets the ID of this header footer.
	 *
	 * @param id the ID of this header footer
	 */
	public void setId(long id);

	/**
	 * Returns the type of this header footer.
	 *
	 * @return the type of this header footer
	 */
	@AutoEscape
	public String getType();

	/**
	 * Sets the type of this header footer.
	 *
	 * @param type the type of this header footer
	 */
	public void setType(String type);

	/**
	 * Returns the data of this header footer.
	 *
	 * @return the data of this header footer
	 */
	@AutoEscape
	public String getData();

	/**
	 * Sets the data of this header footer.
	 *
	 * @param data the data of this header footer
	 */
	public void setData(String data);

	public boolean isNew();

	public void setNew(boolean n);

	public boolean isCachedModel();

	public void setCachedModel(boolean cachedModel);

	public boolean isEscapedModel();

	public Serializable getPrimaryKeyObj();

	public void setPrimaryKeyObj(Serializable primaryKeyObj);

	public ExpandoBridge getExpandoBridge();

	public void setExpandoBridgeAttributes(ServiceContext serviceContext);

	public Object clone();

	public int compareTo(HeaderFooter headerFooter);

	public int hashCode();

	public CacheModel<HeaderFooter> toCacheModel();

	public HeaderFooter toEscapedModel();

	public String toString();

	public String toXmlString();
}