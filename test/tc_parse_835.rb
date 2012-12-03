#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org 
#     
#     Copyright (C) 2012 P&D Technical Solutions, LLC.
#
#     This library is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Lesser General Public
#     License as published by the Free Software Foundation; either
#     version 2.1 of the License, or (at your option) any later version.
#
#     This library is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with this library; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#++
#
require 'x12'
require 'test/unit'

class Test835Parse < Test::Unit::TestCase
  
  def setup    
    @parser = X12::Parser.new('835.xml')
    @msg = []
    # sample 5010 835 test message      
    @temporary = "ISA*00*          *00*          *ZZ*5010TEST       *ZZ*835RECVR       *110930*1105*^*00501*000004592*0*T*:~GS*HP*5010TEST*835RECVR*20110930*100718*45920001*X*005010X221A1~ST*835*0001~BPR*I*57.44*C*CHK************20110930~TRN*1*123456789*1123456789~REF*EV*5010835EXAMPLE~DTM*405*20110930~N1*PR*PAYER NAME~N3*PAYER ADDRESS~N4*CINCINNATI*OH*45206~PER*CX**TE*8003030303~PER*BL*TECHNICAL CONTACT*TE*8004040404*EM*PAYER@PAYER.COM~PER*IC**UR*WWW.PAYER.COM~N1*PE*PROVIDER NAME*XX*1122334455~N3*PROVIDER ADDRESS~N4*CITY*OH*89999~REF*TJ*123456789~LX*1~CLP*EDI DENIAL*1*1088*0*1088*HM*CLAIMNUMBER1*21~NM1*QC*1*LAST*FIRST****MI*1A2A1A2A1A2A~NM1*IL*1*LAST1*FIRST1*G***MI*BBB1A2A1A2A1A2A~NM1*82*1*PROVIDER*MR*A***XX*1234567898~REF*EA*11223344~REF*1L*123456~DTM*232*20090113~DTM*233*20090113~DTM*050*20110908~SVC*HC:00220:P2*1088*0**8**76~DTM*150*20090113~DTM*151*20090113~CAS*PR*29*1088~CLP*EDI PAID*1*100*57.44*30*12*CLAIMNUMBER2*11~NM1*QC*1*LAST2*FIRST2*A***MI*R123456789~NM1*IL*1*LAST3*FIRST3*B***MI*R1234567~NM1*82*1*PROVIDER1*MRS1*B***XX*1234567899~REF*EA*11223344~REF*1L*123456~DTM*232*20110729~DTM*233*20110729~DTM*050*20110927~SVC*HC:97110*100*57.44**2~DTM*150*20110729~DTM*151*20110729~CAS*PR*3*30~CAS*CO*45*12.56~AMT*B6*87.44~SE*45*0001~GE*1*45920001~IEA*1*000004592~"
    @msg << @temporary 
    
    @r = @parser.parse('835', @msg[0])       
  end
  
  def teardown
    #nothing
  end
  
  def test_ISA_IEA
     assert_equal('ISA*00*          *00*          *ZZ*5010TEST       *ZZ*835RECVR       *110930*1105*^*00501*000004592*0*T*:~', @r.ISA.to_s)
     assert_equal('5010TEST       ', @r.ISA.InterchangeSenderId)
     assert_equal('1', @r.IEA.NumberOfIncludedFunctionalGroups)
  end # test_ST

  def test_GS_GE
    assert_equal("HP", @r.GS.FunctionalIdentifierCode)
    assert_equal("45920001", @r.GS.GroupControlNumber)
    assert_equal(@r.GS.GroupControlNumber, @r.GE.GroupControlNumber)
  end
  
  
  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @parser.parse('835', @msg[1])
    end
    finish = Time::now
    puts sprintf("Parses per second, 835: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing
end

