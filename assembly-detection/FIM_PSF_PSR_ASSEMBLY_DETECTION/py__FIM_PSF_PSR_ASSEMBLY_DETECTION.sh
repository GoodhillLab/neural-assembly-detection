#!/bin/bash
set -o nounset

#py__FIM_PSF_PSR_ASSEMBLY_DETECTION ACTIVITY_FIM_RASTER_file
#
#
#   === Jan Moelter, The University of Queensland, 2018 ===================
#

SCRIPT=$( readlink --canonicalize $0 )
ROOT=$( dirname $SCRIPT )


ACTIVITY_FIM_RASTER_DAT=$1
FIM_PSF_PSR_ASSEMBLIES_DAT=${ACTIVITY_FIM_RASTER_DAT/_ACTIVITY-FIM-RASTER.dat/_FIM-PSF-PSR-ASSEMBLIES.dat}

if [[ -e "${ACTIVITY_FIM_RASTER_DAT}" ]]; then
	if ! [[ -e "${FIM_PSF_PSR_ASSEMBLIES_DAT}" ]]; then
		python ${ROOT}/psf+psr/psf+psr/fim+psf+psr.py -tc -uc -s-6 -gp -c1000 -Z2 -RS -S0 -v" [supp=%d]" "${ACTIVITY_FIM_RASTER_DAT}" "${FIM_PSF_PSR_ASSEMBLIES_DAT}"
	fi

	( >&1 echo ">> END PROGRAM" )
	( >&2 echo ">> END PROGRAM" )
fi
