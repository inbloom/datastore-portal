package org.slc.sli.client;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Simple application entity
 *
 * @author David Wu
 * @author Robert Bloh
 *
 */
public class GenericEntity extends LinkedHashMap<String, Object> {

    private static final long serialVersionUID = -1398693068211322783L;

    public GenericEntity() {
        super();
    }

    public GenericEntity(Map<String, Object> map) {
        super(map);
    }

    public String getId() {
        return getString("id");
    }

    public String getString(String key) {
        return (String) (get(key));
    }

    @SuppressWarnings("rawtypes")
    public List getList(String key) {
        @SuppressWarnings("unchecked")
        List<Object> list = (List<Object>) (get(key));
        return list == null ? Collections.emptyList() : list;
    }

    public void appendToList(String key, GenericEntity obj) {
        if (!containsKey(key)) {
            put(key, new ArrayList<GenericEntity>());
        }
        @SuppressWarnings("unchecked")
        List<GenericEntity> list = (List<GenericEntity>) get(key);
        list.add(obj);
        put(key, list);
    }
}