package org.slc.sli.common.util.performance;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation for Profiling Methods
 *
 * @author ifaybyshev
 *
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Profiled {

  /**
   * Profiling level
   * @return level
   */
  String level() default "INFO";

}