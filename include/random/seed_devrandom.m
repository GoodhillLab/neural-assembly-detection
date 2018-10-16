function [ output_args ] = seed_devrandom( verbose )
%SEED_DEVRANDOM( verbose ) Seeds the internal random number generator from
%the /dev/urandom device (only on Unix systems).
%
%   INPUT:
%   verbose [boolean]
%
%   OUPUT:
%   output_args [scalar]: 4 byte random seed
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

narginchk( 0 , 1 );
if( nargin == 0 )
    verbose = true;
end

if( isunix )
    try
        if( verbose )
            fprintf( 1 , [ 'Opening /dev/urandom for reading 4 byte random seed ...' '\n' ] );
        end
        
        dev_random_ = fopen( '/dev/urandom' , 'r' );
        seed_ = typecast( uint8( fread( dev_random_ , 4 ) ), 'uint32' );
        fclose( dev_random_ );
        
        if( verbose )
            fprintf( 1 , [ ' 4 byte random seed is 0x' dec2hex( seed_ , 8 ) '.' '\n' ] );
        end
        rng( seed_ , 'twister' );
    catch
        if( verbose )
            fprintf( 1 , [ ' Reading 4 byte random seed from /dev/urandom failed.' '\n' ] );
        end
        rng( 'shuffle' , 'twister' );
    end
else
    rng( 'shuffle' , 'twister' );
end

RNG = rng;
output_args = RNG.Seed;

if( verbose )
    fprintf( 1 , [ '\n' ] );
    fprintf( 1 , [ 'Internal random number generator was initialised with seed 0x' dec2hex( RNG.Seed , 8 ) '.' '\n' ] );
    fprintf( 1 , [ '\n' ] );
end

end
