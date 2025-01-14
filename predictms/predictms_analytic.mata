*! version 1.0.0 ?????2015 MJC

version 12.1

local ss 	string scalar
local RS	real scalar
local NM	numeric matrix
local RM 	real matrix
local RC	real colvector
local TR	transmorphic
local RR	real rowvector
local PS	pointer(struct predictms_struct scalar) scalar
local SS	struct predictms_struct scalar
local gml 	struct merlin_struct scalar
local Pcm	pointer(struct merlin_struct scalar) colvector

mata:

// illness-death
void predictms_analytic(`SS' S, `RS' from)
{
	`Pcm' Pmerlin
	Pmerlin = J(S.Ntrans,1,NULL)
	Nobs	= rows(S.predtime)
	
	//setup
	for (s=1; s<=S.Ntrans; s++) {
		b		= predictms_get_b(S,s)
		Pmerlin[s] 	= predictms_merlin_setup(S,b,Nobs,s)
	}
	
	//predict
	if 	(S.nicode==1) 	predictms_analytic_survival(S,Pmerlin,Nobs)
	else if (S.nicode==2) 	predictms_analytic_cr(S,Pmerlin,Nobs)
	else if (S.nicode==3) 	predictms_analytic_illd(S,from,Pmerlin,Nobs)
	else			predictms_analytic_extilld(S,from,Pmerlin,Nobs)
	
	//tidyup
	for (s=1; s<=S.Ntrans; s++) rmexternal(st_local("GML"+strofreal(s))) 	
}

end

