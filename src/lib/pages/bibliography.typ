#import "../util.typ": insert_blank_page

#let create_page(
  bibliography: []
) = context [
  #bibliography
  <BIB_BEGIN>
  #hide("BIB_END")
  <BIB_END>
  #insert_blank_page(<BIB_BEGIN>, <BIB_END>)
]