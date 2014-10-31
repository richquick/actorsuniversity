[![Code Climate](https://codeclimate.com/repos/52a71f2c89af7e1a74000748/badges/055e27647b459665bdd8/gpa.png)](https://codeclimate.com/repos/52a71f2c89af7e1a74000748/feed)

Notes for future developers
===========================

Let me preface everything by saying, the above link may not work when you see it, but at
the time of writing it says 4.0 GPA on code climate.
That said, this is not a project with zero technical debt. Even though the code may be
superficially polished, and/or clean looking.

I'm going to try and make as many notes as I can of decisions that have been
made and development directions during my last week here.
Please update this file as and when it becomes irrelevant/relevant.

External Services Used
======================

* Honeybadger
* New relic (not a paid account yet)
* Semaphore (build currently failing after some as yet not understood change on the semaphore side, debugger gem seems to be getting pulled in, I think)
* Trello
* Lighthouse


Tests
=====

General philosophy has been to try and build with the minimal number of tests
possible, rather than full TDD. So you'll notice there's a bunch of
rspec/capybara acceptance tests and then bits and pieces tested elsewhere.
This has been a very short project with a lot of required functionality and
unless it's actually sold to clients all effort in building an incredibly
maintainable stable app that never sees public use could be wasted.  With that
in mind, the intention was always to start expanding upon the test suite if
  * We got paying clients
  * We had any more than one developer on the project

So far the number of bugs discovered as a result of this more lax
approach to testing has been pretty minimal, so all in all, as a pragmatic 
means of delivering value to the business, it's been a succesful experiment.

I'd urge you to not just blindly continue this trend, but rather focus the
right amount of effort on building out functionality and/or tests and
stabilizing/abstracting the codebase in the right direction.

Another issue you may notice is some of the capybara tests that also talk
directly to AR, this is just a compromise of convenience/speed over doing
things in a pure blackbox way.

I've found zeus to work particularly well with this project and would recommend
it for your workflow.

Setup
=====

Setup a default user and admin
rake devise:setup



Deployments
===========

This app can be deployed to heroku on a number of different apps

  * svelte-actors-university  http://svelte.actorsuniversity.com/
  * staging-actors-university http://staging.actorsuniversity.com/


Svelte is an example initial potential client deploy(s).

Make sure you have the following in your .git/config

```
[remote "origin"]
	url = git@github.com:richquick/actors-university.git
	fetch = +refs/heads/*:refs/remotes/origin/*

[branch "master"]
	remote = origin
	merge = refs/heads/master

[remote "staging"]
	url = git@heroku.com:staging-actors-university.git
	fetch = +refs/heads/*:refs/remotes/heroku/*

[remote "svelte"]
	url = git@heroku.com:svelte-actors-university.git
	fetch = +refs/heads/*:refs/remotes/svelte/*
```

Asset precompilation on heroku is _ssssllllow_ so we've been doing the not so desirable thing
of precompiling locally, commiting and removing from the repo. Which is painful, and error prone,
but marginally less painful than waiting for heroku.
The SECRET_KEY_BASE is just so we can have separate env variables for each deploy and our
production credentials are not in version control

```
SECRET_KEY_BASE=doesnt_matter RAILS_ENV=production rake assets:precompile
git add .
git commit "ran rake assets:precompile"
``` 

Then deploy with

```
git push staging master
git push svelte master
```

to run migrations:
```

heroku run rake db:migrate -a staging-actors-university
heroku run rake db:migrate -a svelte-actors-university
```

Philosophy
==========


The philosophy has been to build as much as possible with as flexible as
possible an approach. Where corners have been cut in the code or in the sass
etc we've tried to label with TECHDEBT so that they can be removed later.

This has proved useful as sometimes TECHDEBT stays until the
feature/functionality just isn't required any more and so fixing it would have
been a waste of time.

Some simple scripts to give you an idea of the volume of TECHDEBT

in the app:

```
ack TECHDEBT app | grep TECHDEBT | grep -v stylesheets | wc
```


in stylesheets:

```
ack TECHDEBT app/assets/stylesheets | grep TECHDEBT | wc
```


The mantra should be:

`
"What's the cost of fixing this now vs fixing this later"
`

There's one school of thought which would be that to build everything fully TDD
and with good OOP and levels of abstractions at every level, you'll be thanking
yourself later.

The flip-side of that coin is that sometimes you build too much, build in the
wrong direction or just have to throw away ideas.  Finding the right balance
between these extremes is a challenge we've been trying to manage with this
project.

The cost of fixing a piece of badly coded non-isolated code later on in the
project lifecycle is absolutely going to be more to do later, however, if that
piece of code is either well isolated, or is just removed at a later date, then
the cost of fixing it previously would have been greater than leaving it in the
codebase until it's removed.


Known Issues
===========

Pseudo assignment
-----------------

One idea that was probably a bad decision was deciding on pseudo-assignment of
users to courses and lessons, etc.

The thinking was

User -> Group -> Course -> Lesson

Where Group or Course are kind of optional, but actually connected in the database
by dynamically created pseudo groups and courses for each User and Lesson respectively.
We then have a default scope that ignores the pseudo courses and groups.

A bit handwavy, and this seems to be causing a bunch of trouble in general, and
it's probably worth ripping out and replacing with direct connections between
the Users and Lessons, etc.  Or probably a polymorphic association
`is_allocated_to` or something.

Another related, potential creeping anti-pattern is that the user will visit a Course
show page, and it shows information specific to their progress through that
course.  We have a model for this: Allocation::CourseToGroup (which shows the
complete by date). We may also want to pull in information on
Allocation::UserToCourse, to calculate the day a user should actually complete
a course by.
It seems to me that centring this resource/page on the course itself and not on the
related Allocation:: models, may be a mistake. Where visiting
/allocation_course_to_group/1/course might make more sense. (Just my initial thoughts)



New lesson form
---------------

The new lesson form with background uploading via JS feels a bit hacky.
It also seems to leak into the DAO and feels quite complex. I'm sure there's a
simpler solution for this.


I18n
====

After discovering the I15r gem, I realised it probably wasn't a particularly efficient usage
of time doing I18n up-front in the views, so it's not 100% I18n.

