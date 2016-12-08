/* from http://asura.iaigiri.com/OpenGL/gl68.html */

float ComputeSH( int l, int m, float theta, float phi )
{
    assert( l >= 0 );
    assert( -l <= m && m <= l );

    float result = ScalingFactor( l, m );

    if ( 0 < m )
    { result *= sqrt( 2.0f ) * cos( m * phi ) * LegendrePolynomials( l, m, cos( theta ) ); }
    else if ( m < 0 )
    { result *= sqrt( 2.0f ) * sin( -m * phi ) * LegendrePolynomials( l, -m, cos( theta ) ); }
    else
    { result *= LegendrePolynomials( l, m, cos( theta ) ); }

    return result;
}
float ScalingFactor( int l, int m )
{
    float lpm = 1.0f;
    float lnm = 1.0f;

    if ( m < 0 ) { m = -m; }

    for( int i=(l-m); 0<i; i-- ) { lnm *= i; }
    for( int i=(l+m); 0<i; i-- ) { lpm *= i; }

    return sqrt( ( ( 2.0f * l + 1.0f ) * lnm ) / ( 4.0f * PI * lpm ) );
}

float LegendrePolynomials( int l, int m, float x )
{
    float pmm = 1.0f;

    if ( 0 < m )
    {
        float somx2 = sqrt( ( 1.0f - x ) * ( 1.0 + x ) );
        float fact = 1.0f;
        for( int i=1; i<=m; i++ ) 
        {
            pmm *= (-fact) * somx2;
            fact += 2.0f;
        }
    }
    if ( l == m ) { return pmm; }

    float pmmp1 = x * ( 2.0f * m + 1.0f ) * pmm;
    if ( l == (m + 1) ) { return pmmp1; }

    float pll = 0.0f;

    for( int ll=(m + 2); ll<=l; ll++ )
    {
        pll = ( (2.0f * ll - 1.0f ) * x * pmmp1 - ( ll + m - 1.0f ) * pmm ) / (ll - m);
        pmm = pmmp1;
        pmmp1 = pll;
    }

    return pll;
}