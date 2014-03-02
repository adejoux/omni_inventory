FactoryGirl.define do
  factory :report do
    main_type "lsdf"
    main_type_fields "name"
    parent_type "servers"
    parent_type_fields "name"
  end
end
