#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

typedef SV* SVREF;

static int
autoweak_set(pTHX_ SV* const sv, MAGIC* const mg){
	(void)(mg); /* unused */

	if(!SvWEAKREF(sv)){
		sv_rvweaken(sv);
	}

	return 0; /* success */
}

MGVTBL autoweaker_vtbl = {
	NULL, /* get */
	autoweak_set,
	NULL, /* len */
	NULL, /* clear */
	NULL, /* free */
	NULL, /* copy */
	NULL, /* dup */
#ifdef MGf_LOCAL
	NULL,  /* local */
#endif
};


static bool
isautoweak(pTHX_ SV* const sv){
	if(SvMAGICAL(sv)){
		MAGIC* mg;
		for(mg = SvMAGIC(sv); mg; mg = mg->mg_moremagic){
			if(mg->mg_virtual == &autoweaker_vtbl){
				return TRUE;
			}
		}
	}
	return FALSE;
}

MODULE = WeakRef::Auto	PACKAGE = WeakRef::Auto

PROTOTYPES: DISABLE

void
autoweaken(SVREF var)
PROTOTYPE: \$
CODE:
	SvGETMAGIC(var);

	if(SvREADONLY(var)){
		Perl_croak(aTHX_ PL_no_modify);
	}

	if(!isautoweak(aTHX_ var)){
		sv_magicext(var, NULL, PERL_MAGIC_ext, &autoweaker_vtbl, NULL, 0);
		SvSETMAGIC(var);
	}
