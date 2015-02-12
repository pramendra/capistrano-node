## Capistrano Setup


1.  ##### Confirm if Ruby is installed. 

  > Hit follwing cmd on termial
  > 
  > **ruby -v**
  > 
  >   *ruby 2.1.4p265 (2014-10-27 revision 48166) [x86_64-darwin14.0]*

2. ##### gem install capistrano
  Install ruby gem upon confirmation

3. ##### cap install STAGES=staging,production
  Create scaffolding for different stages

  ```
  mkdir -p config/deploy 
  create config/deploy.rb 
  create config/deploy/staging.rb 
  create config/deploy/production.rb 
  mkdir -p lib/capistrano/tasks
  ```
  **Directory Tree**
  
  ``` 
  Root
  ├── Capfile
  ├── config
  │   ├── deploy
  │   │   ├── production.rb
  │   │   └── staging.rb
  │   └── deploy.rb
  └── lib
      └── capistrano
          └── tasks
  ```


4. ##### Configure different deploys in 
  > config/deploy.rb
5. ##### Define server(s) per role in stages
  > config/deploy/production.rb
  > config/deploy/staging.rb
6. By now all setup is done 
  > Confirm by hitting 
  
  > cap staging deploy --dry-run
 

#### Upon confirmation following commands is avaliable

> Syntax
> 
> cap environment deploy(module):task
> 
> 
> **cap production deploy**
> 
>runs all task under deploy 
> 
> 
> **cap production deploy:rollback**
> 
>runs rollback to previous stage 
> 
> **cap production deploy:restart**
> 
>runs restart task under deploy 
> 
> 
> **cap production node:restart**
> 
>runs restart task under node 
> 
> 
> **cap production node:stop**
> 
>runs stop task under node. ie kill node process 

### What is capistrano and how it works 

> http://www.slideshare.net/neoramax/capistrano-34278510

Capistranor implementation for S3 bucket

> https://github.com/hooktstudios/capistrano-s3

