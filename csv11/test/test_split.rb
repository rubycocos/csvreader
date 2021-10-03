# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_split.rb


require 'helper'


class TestSplit < MiniTest::Test

  def test_split

    assert_equal ['a', 'b', 'c'], Values.split( 'a,b,c' )
    assert_equal ['a', 'b', 'c'], Values.split( 'a, b, c' )
    assert_equal ['a', 'b', ''], Values.split( 'a, b,' )
    assert_equal ['a', 'b'], Values.split( 'a, b' )

    assert_equal ['a', ['n','b'], ['m','c'],'d'], Values.split( 'a,n:b,m:c,d' )
    assert_equal ['a', ['n','b'], ['m','c'],'d'], Values.split( 'a, n: b, m: c, d' )

    ## check reserved names (e.g. http and https)
    assert_equal ['a', 'http://example.com', 'b'], Values.split( 'a, http://example.com, b' )
    assert_equal ['a', 'http://example.com:80', 'b'], Values.split( 'a, http://example.com:80, b' )
    assert_equal ['a', 'https://example.com', 'b'], Values.split( 'a, https://example.com, b' )
    assert_equal ['a', 'https://example.com:80', 'b'], Values.split( 'a, https://example.com:80, b' )
    assert_equal ['https://example.com'],    Values.split( 'https://example.com' )
    assert_equal ['https://example.com:80'], Values.split( 'https://example.com:80' )

    assert_equal ['a', 'n n: b', 'm&m: c','d'], Values.split( 'a, n n: b, m&m: c, d' )

    assert_equal [%{Hello, World!}], Values.split( %{"Hello, World!"} )
    assert_equal [%{Hello, World!}], Values.split( %{'Hello, World!'} )
    assert_equal [%{'Hello, World!'}], Values.split( %{"'Hello, World!'"} )
    assert_equal [%{"Hello, World!"}], Values.split( %{'"Hello, World!"'} )
    assert_equal [%{'Hello, World!'}, %{"Hello, World!"}], Values.split( %{"'Hello, World!'",'"Hello, World!"'} )

    assert_equal [%{The "Quoted" World}], Values.split( %{The "Quoted" World} )   ## no need to escape quotes if not first (letter) of value

    assert_equal [%{'""Hello""', Quotes}], Values.split( %{"""'""Hello""', Quotes"""} )

    ## check single-line named Values  - will IGNORE commas (not special)
    assert_equal [['open', '12h, 13h, 14, 15h']], Values.split( 'open: 12h, 13h, 14, 15h')

    ## check named value with comma escaped with quote
    assert_equal ['a', 'b,c', 'd'], Values.split( %{a,"b,c",d} )
    assert_equal ['a', 'b,c', 'd'], Values.split( %{  a , "b,c" ,  d  } )
    assert_equal ['a', ['n','b,c'], ['m','d,e'],'f,g'], Values.split( %{a,n:"b,c",m:"d,e","f,g"} )

    assert_equal ['a', ['n','b:c'], ['m','d:e'],'f'], Values.split( 'a, n: b:c, m:d:e, f' )
    assert_equal ['a', ['n','b:c'], ['m','d:e:f'],'g h:i:j'], Values.split( 'a,n:b:c,m:d:e:f,g h:i:j' )

    ## note: space in quotes is significant - keep? why ? why not??
    assert_equal ['a', ' b  , c ', 'd'], Values.split( %{  a , " b  , c " ,  d  } )
  end


end  # class TestSplit
