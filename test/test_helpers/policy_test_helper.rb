# frozen_string_literal: true

module PolicyTestHelper
  ANY_ACTION = %i[index? show? create? update? destroy?].freeze
  ANY_VIEW_ACTION = %i[index? show?].freeze
  ANY_INSTANCE_ACTION = %i[show? update? destroy?].freeze
  ANY_INSTANCE_MODIFY_ACTION = %i[update? destroy?].freeze
end
