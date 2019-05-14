# frozen_string_literal: true

class SynchronizedArray
  def initialize(array, semaphore)
    @array = array
    @semaphore = semaphore
  end

  def delete_sample!
    @semaphore.synchronize do
      @array.delete_at(rand(@array.length))
    end
  end
end
