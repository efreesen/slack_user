# Slack User

This is a Slack User that makes available to your Slack channel the ri command, so you can consult the RDoc directly from Slack.

## Usage

First run the following command to setup your app:

```
bin/setup
```

Then you have to set `SLACK_URL` and `SLACK_TOKEN` environment variablesso the app knows where to connect and finally just run:

```
bin/slack_user
```

And you are good to go!

### Example

On Slack type:

```
user [11:52 PM]  
@bot Array#first
```

And the bot replies with the definition like the following:

```

bot [11:52 PM]  
@user, here is the documentation for:

*Array#first*


(from ruby core)
------------------------------------------------------------------------------
 ary.first     ->   obj or nil
 ary.first(n)  ->   new_ary

------------------------------------------------------------------------------

Returns the first element, or the first n elements, of the array. If the array
is empty, the first form returns nil, and the second form returns an empty
array. See also Array#last for the opposite effect.

 a = [ "q", "r", "s", "t" ]
 a.first     #=> "q"
 a.first(2)  #=> ["q", "r"]
```
