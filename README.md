# API2PDF

Pretty-prints JSON-based API to PDF.

![DEMO](http://cl.ly/image/3z3D3R2g1o3T/api2pdf.jpg)

## Usage

    API2PDF.export(
      :url         => "http://ohanapi.herokuapp.com/api/organizations/51a9fd0328217f89770001b2", 
      :file_name   => "HSC", 
      :heading     => "Human Services Providersss"
      :columns     => 2, 
      :page_layout => :landscape, 
      :page_size   => "B5", 
    )

## Installation

Add this line to your application's Gemfile:

    gem 'api2pdf', :git => "https://github.com/codeforamerica/ohana-pdf.git", :branch => 'master'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api2pdf

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details. 