# GrapeLogFormatter


Add a unified custom format for grape logger.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape_log_formatter', git: 'git@github.com:resumecompanion/grape_log_formatter.git'
```

And then execute:

    $ bundle install


## Usage

### Config
In the LoggerSettings add `GrapeLogFormatter::Formatters::CustomFormat` and `GrapeLogFormatter::Loggers::CustomLogging.new`:
```ruby
logger Logger.new GrapeLogging::MultiIO.new(log_file)
logger.formatter = GrapeLogFormatter::Formatters::CustomFormat.new
use GrapeLogging::Middleware::RequestLogger,
  logger: logger,
  include: [GrapeLogging::Loggers::FilterParameters.new,
            GrapeLogFormatter::Loggers::CustomLogging.new] unless Rails.env.test?
```

Add dependency method in user model
```
class user < ApplicationRecord
  def is_temp_user?
   # return boolean type
  end
end
```
Add dependency Constants in initialize
```
NONE = 'NONE'.freeze
```


## Output

```
[2018-08-09 16:39:48] INFO -- severity=INFO duration=368.75 db=11.99 view=356.76 datetime=2018-08-09T16:39:48+08:00 status=200 method=GET path=/api/v3/users/current_user params={} host=localhost user_id=10 temp_user=true controller=V3::UsersApi action=current_user
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
