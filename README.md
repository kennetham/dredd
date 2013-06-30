# Dredd [![Code Climate](https://codeclimate.com/github/xoebus/dredd.png)](https://codeclimate.com/github/xoebus/dredd) [![Build Status](https://travis-ci.org/xoebus/dredd.png)](https://travis-ci.org/xoebus/dredd) [![Coverage Status](https://coveralls.io/repos/xoebus/dredd/badge.png)](https://coveralls.io/r/xoebus/dredd) [![Dependency Status](https://gemnasium.com/xoebus/dredd.png)](https://gemnasium.com/xoebus/dredd)


*Contributor Licence Agreement Enforcer*

![Dredd](media/dredd.jpg)

---

## About

When submitting pull requests to a component of [Cloud Foundry](https://github.com/cloudfoundry)
non-Pivotal employees are required to submit a CLA in order to have
their code merged.

This bot watches for incoming pull requests and checks to see if the
author has signed a CLA. If they have then it does nothing and goes on
its merry way. If they have not then it comments on the pull request to
let the author know what they have to do.

## Usage

1. Copy `config/config.example.yml` to `config/config.yml`.
2. Modify the options (GitHub credentials for the commenter, callback
   URL, callback secret, users to not comment on, and repositories to watch)
   in that file to taste.
3. Push the application to your favourite application hosting service.
4. Rest easy knowing that Judge Dredd is fighting your legal battles for
   you.

## License

    The MIT License (MIT)

    Copyright (c) 2013 Chris Brown

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation files
    (the "Software"), to deal in the Software without restriction,
    including without limitation the rights to use, copy, modify, merge,
    publish, distribute, sublicense, and/or sell copies of the Software,
    and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
    BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
    ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

---

Photo Credit: [rutty](http://www.flickr.com/photos/rutty/498112451/)
