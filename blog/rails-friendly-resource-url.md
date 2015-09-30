---
title: Rails 4 使用资源其他属性构造 URL
created: 2015-07-18
...

在 Rails 4 中，使用  `rails g scaffold Resource` 生成资源后，默认的访问资源的 URL 是 `/resource/1`，如果想用资源的名字访问资源页面，需要修改以下4个文件：

1. app/models/resource.rb
2. app/controllers/resource_controller.rb
3. config/routes.rb
4. test/controllers/resource_controller_test.rb

第一个文件中要在 Resource 类中增加一个 to_param 方法：

~~~~ {.ruby}
def to_param
    name
end
~~~~

第二个文件中将 `set_user` 这一私有方法做如下修改：

~~~~ {.ruby}
 private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      #@resource = Resource.find(params[:id]) =>
      @resource = Resource.find_by_name(params[:name])
    end
~~~~

第三个文件中将默认的 `resources :resources` 改为 `resources :resources, param: :name`。

第四个文件将符号 `:id` 都改为 `:name`。

第二个文件中如果用作 URL 的资源属性是 `page_title`，那么相应的找到资源的方法就是 `Resource.find_by_page_title(params[:page_title]`。Rails 是如何生成方法和构建方法名的，还需要看代码再研究。
