Look at [lib/this_feature/adapters/base.rb](../lib/this_feature/adapters/base.rb) to see the methods that your class should implement. 

Make sure your class inherits from `ThisFeature::Adapters::Base` - this is a requirement. 

You may define a custom `initialize` method - this isn't used by `this_feature` internals because we require an already-constructed instance to be passed into `ThisFeature.configure`. 

For an example, look at one of the existing adapters: [lib/this_feature/adapters/](../lib/this_feature/adapters/)

If you want to include your adapter in our README, just open up a PR.
