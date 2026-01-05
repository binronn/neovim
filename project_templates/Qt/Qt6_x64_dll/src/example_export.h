#ifndef EXAMPLE_EXPORT_H
#define EXAMPLE_EXPORT_H

#include <QtCore/QtGlobal>

#ifdef EXAMPLE_STATIC_DEFINE
#  define EXAMPLE_EXPORT
#  define EXAMPLE_NO_EXPORT
#else
#  ifndef EXAMPLE_EXPORT
#    ifdef example_EXPORTS
        /* We are building this library */
#      define EXAMPLE_EXPORT Q_DECL_EXPORT
#    else
        /* We are using this library */
#      define EXAMPLE_EXPORT Q_DECL_IMPORT
#    endif
#  endif

#  ifndef EXAMPLE_NO_EXPORT
#    define EXAMPLE_NO_EXPORT
#  endif
#endif

#ifndef EXAMPLE_DEPRECATED
#  define EXAMPLE_DEPRECATED Q_DECL_DEPRECATED
#endif

#ifndef EXAMPLE_DEPRECATED_EXPORT
#  define EXAMPLE_DEPRECATED_EXPORT EXAMPLE_EXPORT EXAMPLE_DEPRECATED
#endif

#ifndef EXAMPLE_DEPRECATED_NO_EXPORT
#  define EXAMPLE_DEPRECATED_NO_EXPORT EXAMPLE_NO_EXPORT EXAMPLE_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef EXAMPLE_NO_DEPRECATED
#    define EXAMPLE_NO_DEPRECATED
#  endif
#endif

#endif // EXAMPLE_EXPORT_H